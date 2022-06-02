import faker from "@faker-js/faker";
import prisma from "@prisma/client";

const CARGOS = 10;
const CLIENTES = 100;
const COLABORADORES = 10;
const FORNECEDORES = 5;
const FORNECEDORES_PRODUTOS = 50;
const PEDIDOS = 90;
const PEDIDOS_PRODUTOS = 90;
const PRODUTOS = 50;
const NOTAS_FISCAIS = 140

faker.setLocale("pt_BR");

const client = new prisma.PrismaClient();
const dados = {
  cargos: [],
  clientes: [],
  colaboradores: [],
  fornecedores: [],
  notas_fiscais: [],
  fornecedores_produtos: [],
  pedido_produtos: [],
  pedidos: [],
  produtos: []
};

async function main() {
  console.time("start");

  await client.pedido_produtos.deleteMany()
  await client.pedidos.deleteMany()
  await client.fornecedores_produtos.deleteMany()
  await client.notas_fiscais.deleteMany()
  await client.produtos.deleteMany()
  await client.fornecedores.deleteMany()
  await client.clientes.deleteMany()
  await client.colaboradores.deleteMany()
  await client.cargos.deleteMany()


  await fake_cargos();
  await fake_colaboradores();
  await fake_clientes();
  await fake_fornecedores();
  await fake_produtos();
  await fake_nota_fiscais();
  await fake_fornecedores_produtos();
  await fake_pedidos();
  await fake_pedidos_produtos();


  await client.notas_fiscais.createMany({ data: dados['notas_fiscais'] })
  await client.cargos.createMany({ data: dados['cargos'] })
  await client.colaboradores.createMany({ data: dados['colaboradores'] })
  await client.clientes.createMany({ data: dados['clientes'] })
  await client.fornecedores.createMany({ data: dados['fornecedores'] })
  await client.produtos.createMany({ data: dados['produtos'] })
  await client.pedidos.createMany({ data: dados['pedidos'] })
  await client.pedido_produtos.createMany({ data: dados['pedido_produtos'] })
  await client.fornecedores_produtos.createMany({ data: dados['fornecedores_produtos'] })

  console.timeEnd("start");
}

main();

async function fake_cargos() {
  console.time("Gerando cargos...");

  for (let i = 0; i < CARGOS; i++) {
    // @ts-ignore
    dados["cargos"].push({
      id: faker.datatype.uuid(),
      nome: faker.word.adjective(),
    });
  }

  console.timeEnd("Gerando cargos...");
}

async function fake_colaboradores() {
  console.time("Gerando colaboradores...");

  for (let i = 0; i < COLABORADORES; i++) {
    // @ts-ignore
    const cargo_id = dados["cargos"][faker.datatype.number({ min: 0, max: CARGOS - 1 })].id;

    // @ts-ignore
    dados["colaboradores"].push({
      id: faker.datatype.uuid(),
      nome: faker.name.findName(),
      cpf: faker.finance.account(11),
      status: faker.datatype.boolean(),
      admissao: faker.date.past(),
      demissao: faker.datatype.boolean()
        ? faker.date.soon(
          faker.datatype.number({ min: 1, max: 3650, precision: 0 })
        )
        : null,
      cargo: cargo_id,
    });
  }

  console.timeEnd("Gerando colaboradores...");
}

async function fake_clientes() {
  console.time("Gerando clientes...");

  for (let i = 0; i < CLIENTES; i++) {
    // @ts-ignore
    dados["clientes"].push({
      id: faker.datatype.uuid(),
      nome: faker.name.findName(),
      cpf: faker.finance.account(11),
      bairro: faker.address.country(),
      cidade: faker.address.cityName(),
      estado: faker.address.state(),
      nascimento: faker.date.past(faker.datatype.number({ min: 18, max: 55 }))
    });
  }

  console.timeEnd("Gerando clientes...");
}

async function fake_fornecedores() {
  console.time("Gerando fornecedores...");

  for (let i = 0; i < FORNECEDORES; i++) {
    // @ts-ignore
    dados["fornecedores"].push({
      id: faker.datatype.uuid(),
      nome: faker.company.companyName(),
      cnpj: faker.finance.account(8) + '0001'
    });
  }

  console.timeEnd("Gerando fornecedores...");
}

async function fake_nota_fiscais() {
  console.time("Gerando notas fiscais...")


  for (let i = 0; i < NOTAS_FISCAIS; i++) {
    let codigo
    do {

      codigo = faker.datatype.number({ min: 1, max: 5000 }).toString()
    } while (
      // @ts-ignore
      dados['notas_fiscais'].findIndex(note => note.codigo === codigo) !== -1
    )

    // @ts-ignore
    dados['notas_fiscais'].push({
      id: faker.datatype.uuid(),
      codigo,
    })
  }

  console.timeEnd("Gerando notas fiscais...")

}

async function fake_produtos() {
  console.time("Gerando produtos...");

  for (let i = 0; i < PRODUTOS; i++) {
    // @ts-ignore
    dados["produtos"].push({
      id: faker.datatype.uuid(),
      nome: faker.commerce.product(),
      quantidade: parseInt(faker.finance.amount(0, 1000, 0)),
      preco: faker.finance.amount(0, 500, 2),
    });
  }

  console.timeEnd("Gerando produtos...");
}

async function fake_fornecedores_produtos() {
  console.time("Gerando fornecedores_produtos...")

  for (let i = 0; i < FORNECEDORES_PRODUTOS; i++) {

    let nota_fiscal
    do {
      nota_fiscal = dados['notas_fiscais'][faker.datatype.number({ min: 0, max: NOTAS_FISCAIS - 1 })].codigo
    } while (
      dados['fornecedores_produtos'].findIndex(pp => pp.nota_fiscal === nota_fiscal) !== -1
    )

    for (let j = 0; j < 3; j++) {
      const produto = dados['produtos'][faker.datatype.number({ min: 0, max: PRODUTOS - 1 })].id

      dados['fornecedores_produtos'].push({
        id: faker.datatype.uuid(),
        quantidade: faker.datatype.number({ min: 1, max: 1000 }),
        preco: parseFloat(faker.finance.amount(1, 1000, 2)),
        produto,
        nota_fiscal,
      })
    }
  }

  console.timeEnd("Gerando fornecedores_produtos...")
}

async function fake_pedidos() {
  console.time('Gerando os pedidos...')

  const formas_de_pagamento = ['cartão de crédito', 'cartão de débito', 'dinheiro']

  for (let i = 0; i < PEDIDOS; i++) {
    // @ts-ignore
    const colaborador = dados['colaboradores'][faker.datatype.number({ min: 0, max: COLABORADORES - 1 })].id
    // @ts-ignore
    const cliente = dados['clientes'][faker.datatype.number({ min: 0, max: CLIENTES - 1 })].id


    const forma_de_pagamento = formas_de_pagamento[faker.datatype.number({ min: 0, max: 2 })]

    let codigo
    do {
      codigo = faker.datatype.number({ min: 0, max: 1000 }).toString()

      // @ts-ignore
    } while (dados['pedidos'].findIndex(request => request.codigo === codigo) !== -1);

    // @ts-ignore
    dados['pedidos'].push({
      id: faker.datatype.uuid(),
      colaborador,
      cliente,
      forma_de_pagamento,
      data: faker.date.recent(faker.datatype.number({ min: 1, max: 90 }))
    })
  }

  console.timeEnd('Gerando os pedidos...')
}

async function fake_pedidos_produtos() {
  console.time('Gerando os produtos dos pedidos...')

  for (let i = 0; i < PEDIDOS_PRODUTOS; i++) {
    // @ts-ignore
    const produto = dados['produtos'][faker.datatype.number({ min: 0, max: PRODUTOS - 1 })].id
    // @ts-ignore
    const pedido = dados['pedidos'][faker.datatype.number({ min: 0, max: PEDIDOS - 1 })].id

    let nota_fiscal

    do {
      // @ts-ignore
      nota_fiscal = dados['notas_fiscais'][faker.datatype.number({ min: 0, max: NOTAS_FISCAIS - 1 })].codigo

    } while (
      // @ts-ignore
      dados['pedido_produtos'].findIndex(pp => pp.nota_fiscal === nota_fiscal) !== -1 &&

      // @ts-ignore
      dados['fornecedores_produtos'].findIndex(fp => fp.nota_fiscal === nota_fiscal) !== -1
    )

    for (let j = 0; j < faker.datatype.number({ min: 1, max: 6 }); j++) {
      // @ts-ignore
      dados['pedido_produtos'].push({
        id: faker.datatype.uuid(),
        pedido,
        produto,
        quantidade: faker.datatype.number({ min: 1, max: 3 }),
        nota_fiscal,
      })
    }
  }

  console.timeEnd('Gerando os produtos dos pedidos...')
}


