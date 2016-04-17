"use strict"

//let effects = require("./plugins-old.json");
let effects = require("./plugins.json");


class Efeito {
    constructor(data, categorias, empresas) {
        this.data = data;
        this.categorias = categorias;
        this.empresas = empresas;
    }

    prepare(id) {
        return this.efeito(id, this.data);
    }

    efeito(id, effect) {
        let efeito = {};

        efeito.id = id;
    	efeito.nome = effect.name;
        efeito.descricao = effect.comment.replace(new RegExp("'", 'g'), "''").replace("\n", "");
    	efeito.identificador = effect.uri;
    	efeito.id_tecnologia = 1;//"lv2";

        efeito.empresa = this.empresa(effect);
        efeito.plugs = this.plugs(id, effect.ports);
        efeito.parametros = this.parametros(id, effect.ports);
        efeito.categoriasEfeitos = this.categoriasEfeitos(id, effect.category);

    	return efeito;
    }

    plugs(id_efeito, ports) {
        let plugs = [];

        for (let input of ports.audio.input)
            plugs.push({id_efeito : id_efeito, tipo : 1, nome : input.name});
        for (let input of ports.audio.output)
            plugs.push({id_efeito : id_efeito, tipo : 2, nome : input.name});

        return plugs;
    }

    parametros(id_efeito, ports) {
        let parametros = [];

        for (let input of ports.control.input) {
            let data = {id_efeito : id_efeito, nome : input.name, minimo : input.ranges.minimum, maximo : input.ranges.maximum, valor_padrao : input.ranges.default};
            data.nome = data.nome.replace(new RegExp("'", 'g'), "''").replace("\n", "");
            parametros.push(data);
        }

        return parametros;
    }

    categoriasEfeitos(id_efeito, category) {
        let idCategorias = []
        let categorias = [];

        for (let categoria of category) {
            let idCategoria = this.categorias.indexOf(categoria);
            if (idCategorias.indexOf(idCategoria) == -1) {
                categorias.push({ id_categoria : this.categorias.indexOf(categoria), id_efeito : id_efeito});
                idCategorias.push(idCategoria);
            }
        }

        return categorias;
    }

    empresa(effect) {
        return this.empresas.indexOf(effect.brand);
    }
}

class Categorias {
    constructor(data) {
        this.categorias = [];

        for (let effect of data) {
            for (let categoria of effect.category) {
                if (this.indexOf(categoria) == -1)
                    this.categorias.push(categoria);
            }
        }
    }

    indexOf(categoria) {
        let index = this.categorias.indexOf(categoria);

        return index == -1 ? index : index + 1;
    }

    print() {
        let data = "";
        data += ` INSERT INTO efeito.categoria (id_categoria, nome) \n`;
        data += `      VALUES \n`;

        let id = 1;
        for (let categoria of this.categorias) {
            data += `             (${id}, '${categoria}')`;
            data += id == this.categorias.length ? ';\n' : ',\n';
            id++;
        }

        return data;
    }
}

class Empresas {
    constructor(data) {
        this.empresas = [];

        for (let effect of data) {
            let empresa = {nome: effect.brand, site: effect.author.homepage};
            if (this.indexOf(empresa.nome) == -1)
                this.empresas.push(empresa);
        }
    }

    indexOf(nome) {
        let index = 1;

        for (let empresa of this.empresas) {
            if (empresa.nome == nome)
                return index;
            index++;
        }

        return -1;
    }

    print() {
        let data = "";
        data += ` INSERT INTO efeito.empresa (id_empresa, nome, site) \n`;
        data += `      VALUES \n`;

        let id = 1;
        for (let empresa of this.empresas) {
            data += `             (${id}, '${empresa.nome}', '${empresa.site}')`;
            data += id == this.empresas.length ? ';\n' : ',\n';
            id++;
        }

        return data;
    }
}

class Print {
    constructor(effects) {
        this.efeitos = [];

        this.categorias = new Categorias(effects);
        this.empresas = new Empresas(effects);

        let i = -1;
        for (let effect of effects) {
            i++;
            this.efeitos.push(new Efeito(effects[i], this.categorias, this.empresas).prepare(i+1));
        }
    }

    print() {
        let data = "";

        data += this.empresas.print();
        data += '\n';

        data += this.categorias.print();
        data += '\n';

        data += this.printData(this.effectHeader, effect => this.effect(effect));
        data += this.printDataTipo2(this.categoryHeader, effect => this.category(effect));

        this.id_parametro = 1;
        data += this.printDataTipo2(this.parametrosCabecalho, effect => this.parametros(effect));

        return data;
    }

    printData(header, content) {
        let data = header();

        for (let efeito of this.efeitos)
            data += `           ${content(efeito)},\n`;

        data  = this.replaceAt(data, data.length-2, ";");
        data += '\n';

        return data;
    }

    printDataTipo2(header, content) {
        let data = header();

        for (let efeito of this.efeitos)
            for (let value of content(efeito))
                data += `           ${value},\n`;

        data  = this.replaceAt(data, data.length-2, ";");
        data += '\n';

        return data;
    }

    replaceAt(str, index, character) {
        return str.substr(0, index) + character + str.substr(index+character.length);
    }

    effectHeader() {
        let data = "";
        data += ` INSERT INTO efeito.efeito (id_efeito, nome, descricao, identificador, id_empresa, id_tecnologia) \n`;
        data += `      VALUES \n`;

        return data;
    }

    effect(effect) {
    	return `(${effect.id}, '${effect.nome}', '${effect.descricao}', '${effect.identificador}', ${effect.empresa}, ${effect.id_tecnologia})`;
    }

    categoryHeader() {
        let data = "";
        data += ` INSERT INTO efeito.categoria_efeito (id_categoria, id_efeito) \n`;
        data += `      VALUES \n`;

        return data;
    }

    category(effect) {
        let data = [];
        for (let category of effect.categoriasEfeitos)
            data.push(`(${category.id_categoria}, ${category.id_efeito})`)

        return data;
    }

    parametrosCabecalho(effect) {
        let data = "";
        data += ` INSERT INTO efeito.parametro (id_parametro, id_efeito, nome, minimo, maximo, valor_padrao) \n`;
        data += `      VALUES \n`;

        return data;
    }

    parametros(efeito) {
        let data = [];
        for (let parametro of efeito.parametros)
            data.push(`(${this.id_parametro++}, ${parametro.id_efeito}, '${parametro.nome}', ${parametro.minimo}, ${parametro.maximo}, ${parametro.valor_padrao})`);

        return data;
    }
}



//console.log(new Print(effects).print());
//new Print(effects).print();
let units = {};

for (let efeito of effects) {
    for (let input of efeito.ports.control.input) {
        if (input.units.label == undefined)
            continue;

        units[input.units.label] = input.units;
    }
}

console.log(units);

let properties = [];

for (let efeito of effects) {
    for (let input of efeito.ports.control.input) {
        for (let propertie of input.properties)
            if (properties.indexOf(propertie) == -1)
                properties.push(propertie)
    }
}

console.log(properties);
/*
for (let efeito of effects) {
    for (let input of efeito.ports.control.input) {
        if (input.scalePoints.length > 0) {
            console.log(input);
            console.log(input.scalePoints);
            break;
        }
    }
}
*/
//console.log(effects[57].ports.control.input);
