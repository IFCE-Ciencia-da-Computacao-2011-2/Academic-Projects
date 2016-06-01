"use strict";
const readline = require("readline");
const net = require('net');

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

let cliente = new net.Socket();

cliente.on('data', data => {
    data = data.toString();
    let conteudo = data.split(" ");

    if (conteudo[0] == "iniciar") {
        console.log("Conexão estabelecida");

    } else if (conteudo[0] == "alto") {
        console.log("Chute alto!");
    } else if (conteudo[0] == "baixo") {
        console.log("Chute baixo!");
    } else if (conteudo[0] == "igual") {
        console.log("Acertou! \\o/");
        cliente.destroy();
    } else {
        console.log("Erro!");
    }

    rl.question('Chute: ', chute => cliente.write('chute ' + chute + ' '));
});

cliente.on('close', () => console.log('Conexão finalizada'));

rl.question('IP: ', ip => {
    rl.question('Porta: ', porta => {
        cliente.connect(parseInt(porta), ip, () => cliente.write('iniciar '));
    });
});
