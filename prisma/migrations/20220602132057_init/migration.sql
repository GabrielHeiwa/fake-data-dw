/*
  Warnings:

  - You are about to drop the `account` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `sector` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `transfer` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "account" DROP CONSTRAINT "account_owner_fkey";

-- DropForeignKey
ALTER TABLE "transfer" DROP CONSTRAINT "transfer_account_destiny_fkey";

-- DropForeignKey
ALTER TABLE "transfer" DROP CONSTRAINT "transfer_account_origin_fkey";

-- DropTable
DROP TABLE "account";

-- DropTable
DROP TABLE "sector";

-- DropTable
DROP TABLE "transfer";

-- CreateTable
CREATE TABLE "cargos" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "nome" TEXT NOT NULL,

    CONSTRAINT "cargos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "clientes" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "nome" TEXT NOT NULL,
    "cpf" TEXT NOT NULL,
    "numero" TEXT NOT NULL,
    "bairro" TEXT NOT NULL,
    "cidade" TEXT NOT NULL,
    "estado" TEXT NOT NULL,
    "data_de_nascimento" DATE NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "clientes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "colaboradores" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "nome" TEXT NOT NULL,
    "cpf" TEXT NOT NULL,
    "rg" TEXT NOT NULL,
    "status" BOOLEAN NOT NULL DEFAULT true,
    "data_de_admissao" DATE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "data_de_demissao" DATE DEFAULT CURRENT_TIMESTAMP,
    "telefone" TEXT,
    "cargo" UUID NOT NULL,

    CONSTRAINT "colaboradores_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "fornecedores" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "nome" TEXT NOT NULL,
    "cnpj" TEXT NOT NULL,

    CONSTRAINT "fornecedores_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "pedidos_produtos" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "produto" UUID NOT NULL,
    "quantidade" INTEGER NOT NULL,
    "codigo" TEXT,

    CONSTRAINT "comanda_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "produtos" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "nome" TEXT NOT NULL,
    "em_estoque" INTEGER,
    "preco" DECIMAL NOT NULL,
    "validade" DATE NOT NULL,
    "fornecedor" UUID NOT NULL,

    CONSTRAINT "produtos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "pedidos" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "colaborador" UUID NOT NULL,
    "cliente" UUID NOT NULL,
    "data" DATE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "forma_de_pagamento" TEXT NOT NULL,
    "codigo" TEXT NOT NULL,

    CONSTRAINT "pedido_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "clientes_cpf_key" ON "clientes"("cpf");

-- CreateIndex
CREATE UNIQUE INDEX "colaboradores_cpf_key" ON "colaboradores"("cpf");

-- CreateIndex
CREATE UNIQUE INDEX "colaboradores_rg_key" ON "colaboradores"("rg");

-- CreateIndex
CREATE UNIQUE INDEX "fornecedores_cnpj_key" ON "fornecedores"("cnpj");

-- CreateIndex
CREATE UNIQUE INDEX "pedidos_codigo_key" ON "pedidos"("codigo");

-- AddForeignKey
ALTER TABLE "colaboradores" ADD CONSTRAINT "colaboradores_cargo_fkey" FOREIGN KEY ("cargo") REFERENCES "cargos"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "pedidos_produtos" ADD CONSTRAINT "comanda_produto_fkey" FOREIGN KEY ("produto") REFERENCES "produtos"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "produtos" ADD CONSTRAINT "produtos_fornecedor_fkey" FOREIGN KEY ("fornecedor") REFERENCES "fornecedores"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "pedidos" ADD CONSTRAINT "pedido_cliente_fkey" FOREIGN KEY ("cliente") REFERENCES "clientes"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "pedidos" ADD CONSTRAINT "pedido_colaborador_fkey" FOREIGN KEY ("colaborador") REFERENCES "colaboradores"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;
