use db_medtime;

-- SELECTS
create or replace view vw_dados_usuarios as
select
    tbl_usuarios.id,
    tbl_usuarios.nome,
    tbl_usuarios.foto,
    tbl_usuarios.email,
    tbl_usuarios.cpf,
    tbl_usuarios.telefone,
    tbl_usuarios.data_nascimento,
    tbl_usuarios.ativo,
    tbl_role.role,
    group_concat(distinct tbl_permissoes.permissao separator ', ') as permissoes,
    group_concat(distinct tbl_doencas_cronicas.nome_doenca separator ', ') as doencas_cronicas,
    group_concat(distinct tbl_contato_de_emergencia.telefone separator ', ') as contato_emergencia,
    group_concat(distinct paciente.nome separator ', ') as pacientes_vinculados,
    group_concat(distinct cuidador.nome separator ', ') as cuidador_vinculado
from tbl_usuarios
    left join tbl_usuarios_role
        on tbl_usuarios.id = tbl_usuarios_role.id_usuarios
        and tbl_usuarios_role.ativo = 1

    left join tbl_role
        on tbl_role.id = tbl_usuarios_role.id_role

    left join tbl_role_permissoes
        on tbl_role.id = tbl_role_permissoes.id_role

    left join tbl_permissoes
        on tbl_permissoes.id = tbl_role_permissoes.id_permissoes

    left join tbl_doenca_cronica_usuario
        on tbl_usuarios.id = tbl_doenca_cronica_usuario.id_usuarios

    left join tbl_doencas_cronicas
        on tbl_doencas_cronicas.id = tbl_doenca_cronica_usuario.id_doencas_cronicas

    left join tbl_contato_emergencia_usuarios
        on tbl_usuarios.id = tbl_contato_emergencia_usuarios.id_usuarios

    left join tbl_contato_de_emergencia
        on tbl_contato_de_emergencia.id = tbl_contato_emergencia_usuarios.id_contato_de_emergencia

    left join tbl_vinculo_paciente as vinculo_cuidador
        on tbl_usuarios.id = vinculo_cuidador.id_cuidador

    left join tbl_usuarios as paciente
        on paciente.id = vinculo_cuidador.id_paciente

    left join tbl_vinculo_paciente as vinculo_paciente
        on tbl_usuarios.id = vinculo_paciente.id_paciente

    left join tbl_usuarios as cuidador
        on cuidador.id = vinculo_paciente.id_cuidador

group by
    tbl_usuarios.id,
    tbl_usuarios.nome,
    tbl_usuarios.foto,
    tbl_usuarios.email,
    tbl_usuarios.cpf,
    tbl_usuarios.telefone,
    tbl_usuarios.data_nascimento,
    tbl_usuarios.ativo,
    tbl_role.role;

select * from vw_dados_usuarios;

## ----- Consulta de dados do medicamento --------
create or replace view vw_dados_medicamentos as
select
    tbl_usuarios.nome as nome_paciente,
    tbl_medicamentos.imagem,
    tbl_medicamentos.nome,
    tbl_medicamentos.concentracao,
    tbl_unidade_medida.unidade_medida,
    tbl_tipo_dosagem.tipo_dosagem,
    tbl_receita_medica.dosagem,
    tbl_programacao_medicamento.frequencia,
    tbl_programacao_medicamento.data_hora_inicio,
    tbl_programacao_medicamento.data_hora_fim,
    tbl_receita_medica.descricao,
    tbl_tipo_intervalo.tipo_intervalo,
    tbl_estoque.quantidade_em_estoque
from tbl_receita_medica
    inner join tbl_medicamentos
        on tbl_medicamentos.id = tbl_receita_medica.id_medicamento

    inner join tbl_usuarios
        on tbl_usuarios.id = tbl_receita_medica.id_usuario

    inner join tbl_unidade_medida
        on tbl_medicamentos.id_unidade_medida_embalagem = tbl_unidade_medida.id

    inner join tbl_tipo_dosagem
        on tbl_medicamentos.id_tipo_dosagem = tbl_tipo_dosagem.id

    inner join tbl_programacao_medicamento
        on tbl_programacao_medicamento.id_receita_medica = tbl_receita_medica.id

    inner join tbl_tipo_intervalo
        on tbl_tipo_intervalo.id = tbl_programacao_medicamento.id_tipo_intervalo

    inner join tbl_estoque
        on tbl_estoque.id = tbl_receita_medica.id_estoque
        and tbl_estoque.id_usuarios = tbl_usuarios.id
        and tbl_estoque.id_medicamentos = tbl_medicamentos.id;

select * from vw_dados_medicamentos;

## --- Consulta de dados de agenda médica ---
create or replace view vw_agenda_medicamentos as
select
    tbl_receita_medica.id as id_receita_medica,
    tbl_programacao_medicamento.id as id_programacao_medicamento,
    tbl_programacao_medicamento.frequencia,
    tbl_programacao_medicamento.data_hora_inicio,
    tbl_programacao_medicamento.data_hora_fim,
    tbl_usuarios.id as id_paciente,
    tbl_usuarios.nome as nome_paciente,
    tbl_medicamentos.id as id_medicamento,
    tbl_medicamentos.nome as medicamento,
    tbl_medicamentos.imagem,
    tbl_medicamentos.concentracao,
    unidade_embalagem.unidade_medida as unidade_concentracao,
    unidade_embalagem.sigla as sigla_concentracao,
    tbl_receita_medica.dosagem,
    unidade_dosagem.unidade_medida as unidade_dosagem,
    tbl_tipo_dosagem.tipo_dosagem,
    tbl_tipo_intervalo.tipo_intervalo,
    tbl_estoque.quantidade_em_estoque
from tbl_programacao_medicamento
    inner join tbl_receita_medica
        on tbl_receita_medica.id = tbl_programacao_medicamento.id_receita_medica

    inner join tbl_usuarios
        on tbl_usuarios.id = tbl_receita_medica.id_usuario

    inner join tbl_medicamentos
        on tbl_medicamentos.id = tbl_receita_medica.id_medicamento

    inner join tbl_unidade_medida as unidade_embalagem
        on unidade_embalagem.id = tbl_medicamentos.id_unidade_medida_embalagem

    inner join tbl_unidade_medida as unidade_dosagem
        on unidade_dosagem.id = tbl_receita_medica.id_unidade_medida

    inner join tbl_tipo_dosagem
        on tbl_tipo_dosagem.id = tbl_medicamentos.id_tipo_dosagem

    inner join tbl_tipo_intervalo
        on tbl_tipo_intervalo.id = tbl_programacao_medicamento.id_tipo_intervalo

    inner join tbl_estoque
        on tbl_estoque.id = tbl_receita_medica.id_estoque
        and tbl_estoque.id_usuarios = tbl_usuarios.id
        and tbl_estoque.id_medicamentos = tbl_medicamentos.id;

select * from vw_agenda_medicamentos;

## --- Consulta de dados básicos para JWT do usuário
create or replace view vw_dados_usuarios_JWT as
select
    tbl_usuarios.id,
    tbl_usuarios.nome,
    tbl_usuarios.email,
    tbl_usuarios.senha,
    tbl_usuarios.ativo,
    tbl_role.id as id_role,
    tbl_role.role,
    group_concat(distinct tbl_permissoes.permissao separator ', ') as permissoes
from tbl_usuarios
    inner join tbl_usuarios_role
        on tbl_usuarios.id = tbl_usuarios_role.id_usuarios
        and tbl_usuarios_role.ativo = 1

    inner join tbl_role
        on tbl_role.id = tbl_usuarios_role.id_role

    inner join tbl_role_permissoes
        on tbl_role.id = tbl_role_permissoes.id_role

    inner join tbl_permissoes
        on tbl_permissoes.id = tbl_role_permissoes.id_permissoes

group by
    tbl_usuarios.id,
    tbl_usuarios.nome,
    tbl_usuarios.email,
    tbl_usuarios.senha,
    tbl_usuarios.ativo,
    tbl_role.id,
    tbl_role.role;

select * from vw_dados_usuarios_JWT;

## --- Consulta de role e permissões vinculadas --- 
create or replace view vw_role_permissoes as
select
    tbl_role.id as id_role,
    tbl_role.role,
    group_concat(tbl_permissoes.permissao separator ', ') as permissoes
from tbl_role_permissoes
    inner join tbl_role
        on tbl_role.id = tbl_role_permissoes.id_role

    inner join tbl_permissoes
        on tbl_permissoes.id = tbl_role_permissoes.id_permissoes

group by
    tbl_role.id,
    tbl_role.role;

select * from vw_role_permissoes;