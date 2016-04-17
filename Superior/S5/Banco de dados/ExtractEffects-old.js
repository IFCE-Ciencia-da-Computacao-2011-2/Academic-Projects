"use strict"

//let effects = require("./plugins-old.json");
let effects = require("./plugins.json");
console.log(effects[57]);

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
        efeito.descricao = effect.description.replace(new RegExp("'", 'g'), "''").replace("\n", "");
    	efeito.identificador = effect.url;
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

        for (let input of ports.control.input)
            parametros.push({id_efeito : id_efeito, nome : input.name, minimo : input.minimum, maximo : input.maximum, valor_padrao : input.default});

        return parametros;
    }

    categoriasEfeitos(id_efeito, category) {
        let categorias = [];

        for (let categoria of category)
            categorias.push({ id_categoria : this.categorias.indexOf(categoria), id_efeito : id_efeito});

        return categorias;
    }

    empresa(effect) {
        return this.empresas.indexOf(effect.gui.templateData.author);
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
        this.empresas = [
            {nome: 'GUITARIX',         site: 'http://guitarix.org/'},
            {nome: 'CALF', site: 'http://calf-studio-gear.org/'},
            {nome: 'MOD',      site: 'http://moddevices.com/'},
            {nome: 'TAP',              site: 'http://tap-plugins.sourceforge.net/'},
            {nome: 'CAPS',             site: 'http://quitte.de/dsp/caps.html'},
            {nome: 'ARTYFX',           site: 'http://openavproductions.com/artyfx/'}
        ];

        /*
        this.empresas = [];

        for (let effect of data) {
            if (effect.developer == null || effect.gui.templateData == null)
                continue;

            let empresa = {nome: effect.gui.templateData.author, site: effect.developer.homepage};
            if (this.indexOf(empresa) == -1)
                this.empresas.push(empresa);
        }

        let nomes = [];
        for (let empresa of this.empresas) {
            if (nomes.indexOf(empresa.nome) == -1)
                nomes.push(empresa.nome);
        }
        */
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
            if (effect.developer == null || effect.gui.templateData == null)
                continue;

            this.efeitos.push(new Efeito(effects[i], this.categorias, this.empresas).prepare(i+1));
        }
    }

    print() {
        let data = "";

        data += this.empresas.print();
        data += '\n';

        data += this.categorias.print();
        data += '\n';

        data += this.effectHeader();
        for (let efeito of this.efeitos)
            data += "           " + this.effect(efeito) + ",\n";
        data  = this.replaceAt(data, data.length-2, ";");
        data += '\n';

        data += this.categoryHeader();
        for (let efeito of this.efeitos)
            for (let categoria of this.category(efeito))
                data += "           " + categoria + ",\n";
        data  = this.replaceAt(data, data.length-2, ";");
        data += '\n';

        console.log(data);
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
}



new Print(effects).print();
