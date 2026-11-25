-- ============ PROCEDURE =============
use db_medtime;

-- ======== TABELA TIPO INTERVALO ========
DELIMITER $$
create procedure procTipoIntervalo(
	IN operacao varchar(30),
    IN tipo_intervalo_param varchar(5),
    IN id_param int
)
BEGIN
	if operacao = 'INSERT' then
		insert into tbl_tipo_intervalo (
			tipo_intervalo
        ) values (
			tipo_intervalo_param
        );
        select last_insert_id() as id;
        
	elseif operacao = 'UPDATE' then
		update tbl_tipo_intervalo
        set tipo_intervalo = tipo_intervalo_param
        where id = id_param;
        select row_count() as affectedRows;
        
	elseif operacao = 'SELECT_ALL' then
		select * from tbl_tipo_intervalo order by id desc;
        
	elseif operacao = 'SELECT_BY_ID' then
		select * from tbl_tipo_intervalo where id = id_param;
        
	elseif operacao = 'DELETE' then
		delete from tbl_tipo_intervalo where id = id_param;
        
	else
		signal sqlstate '45000'
        set message_text = 'Operação inválida na procTipoIntervalo';
	end if;
END $$
DELIMITER $$

-- ======== CONTATOS DE EMERGENCIA ========
DELIMITER $$
create procedure procContatoEmergencia(
	IN operacao varchar(30),
    IN nome_param varchar(80),
    IN telefone_param varchar(20),
    IN id_param int
)
BEGIN
	if operacao = 'INSERT' then
		insert into tbl_contato_de_emergencia (
			nome,
            telefone
        ) values (
			nome_param,
            telefone_param
        );
        select last_insert_id() as id;
	
    elseif operacao = 'UPDATE' then
		update tbl_contato_de_emergencia
        set nome = nome_param,
			telefone = telefone_param
		where id = id_param;
        select row_count() as affectedRows;
        
	elseif operacao = 'SELECT_ALL' then
		select * from tbl_contato_de_emergencia order by id desc;
        
	elseif operacao = 'SELECT_BY_ID' then
		select * from tbl_contato_de_emergencia where id = id_param;
        
	elseif operacao = 'DELETE' then
		delete from tbl_contato_de_emergencia where id = id_param;
        
	else
		signal sqlstate '45000'
        set message_text = 'Operação inválida na procContatoEmergencia';
	end if;
END $$
DELIMITER $$

-- ======== CONTATOS DE EMERGENCIA USUARIOS ========
DELIMITER $$
create procedure procContatoEmergenciaUsuarios(
	IN operacao varchar(30),
    IN id_contato_de_emergencia_param int,
    IN id_usuarios_param int,
    IN id_param int
)
BEGIN
	if operacao = 'INSERT' then
		insert into tbl_contato_emergencia_usuarios (
			id_contato_de_emergencia,
            id_usuarios
        ) values (
			id_contato_de_emergencia_param,
            id_usuarios_param
        );
        select last_insert_id() as id;
	
    elseif operacao = 'UPDATE' then
		update tbl_contato_emergencia_usuarios
        set id_contato_de_emergencia = id_contato_de_emergencia_param,
			id_usuarios = id_usuarios_param
		where id = id_param;
        select row_count() as affectedRows;
        
	elseif operacao = 'SELECT_ALL' then
		select
			tbl_usuarios.id as id_usuario,
			tbl_usuarios.nome as nome_usuario,
			tbl_usuarios.email as email_usuario,
			tbl_usuarios.cpf as cpf_usuario,
			tbl_usuarios.data_nascimento as data_nascimento_usuario,
			tbl_contato_de_emergencia.id as id_contato_de_emergencia,
			tbl_contato_de_emergencia.nome as nome_contato, 
			tbl_contato_de_emergencia.telefone as telefone_contato
		from tbl_contato_emergencia_usuarios
		left join tbl_usuarios
			on tbl_usuarios.id = tbl_contato_emergencia_usuarios.id_usuarios
		left join tbl_contato_de_emergencia
			on tbl_contato_de_emergencia.id = tbl_contato_emergencia_usuarios.id_contato_de_emergencia
		order by tbl_contato_emergencia_usuarios.id desc;
        
	elseif operacao = 'SELECT_BY_ID' then
		select
			tbl_usuarios.id as id_usuario,
			tbl_usuarios.nome as nome_usuario,
			tbl_usuarios.email as email_usuario,
			tbl_usuarios.cpf as cpf_usuario,
			tbl_usuarios.data_nascimento as data_nascimento_usuario,
			tbl_contato_de_emergencia.id as id_contato_de_emergencia,
			tbl_contato_de_emergencia.nome as nome_contato, 
			tbl_contato_de_emergencia.telefone as telefone_contato
		from tbl_contato_emergencia_usuarios
		left join tbl_usuarios
			on tbl_usuarios.id = tbl_contato_emergencia_usuarios.id_usuarios
		left join tbl_contato_de_emergencia
			on tbl_contato_de_emergencia.id = tbl_contato_emergencia_usuarios.id_contato_de_emergencia
		where tbl_contato_emergencia_usuarios.id = id_param;
        
	elseif operacao = 'DELETE' then
		delete from tbl_contato_emergencia_usuarios where id = id_param;
        select row_count() as affectedRows;
        
	else
		signal sqlstate '45000'
        set message_text = 'Operação inválida na procContatoEmergenciaUsuarios';
	end if;
END $$
DELIMITER $$

-- ======== DOENÇAS CRONICAS ========
DELIMITER $$
create procedure procDoencaCronica(
	IN operacao varchar(30),
    IN nome_doenca_param varchar(45),
    IN id_param int
)
BEGIN
	if operacao = 'INSERT' then
		insert into tbl_doencas_cronicas (
			nome_doenca
        ) values (
			nome_doenca_param
        );
        select last_insert_id() as id;
	
    elseif operacao = 'UPDATE' then
		update tbl_doencas_cronicas
        set nome_doenca = nome_doenca_param
		where id = id_param;
        select row_count() as affectedRows;
        
	elseif operacao = 'SELECT_ALL' then
		select * from tbl_doencas_cronicas order by id desc;
        
	elseif operacao = 'SELECT_BY_ID' then
		select * from tbl_doencas_cronicas where id = id_param;
        
	elseif operacao = 'DELETE' then
		delete from tbl_doencas_cronicas where id = id_param;
        
	else
		signal sqlstate '45000'
        set message_text = 'Operação inválida na procDoencaCronica';
	end if;
END $$
DELIMITER $$

-- ======== PERMISSOES ========
DELIMITER $$
create procedure procPermissoes(
	IN operacao varchar(30),
    IN permissao_param varchar(45),
    IN id_param int
)
BEGIN
	if operacao = 'INSERT' then
		insert into tbl_permissoes (
			permissao
        ) values (
			permissao_param
        );
        select last_insert_id() as id;
	
    elseif operacao = 'UPDATE' then
		update tbl_permissoes
        set permissao = permissao_param
		where id = id_param;
        select row_count() as affectedRows;
        
	elseif operacao = 'SELECT_ALL' then
		select * from tbl_permissoes order by id desc;
        
	elseif operacao = 'SELECT_BY_ID' then
		select * from tbl_permissoes where id = id_param;
        
	elseif operacao = 'DELETE' then
		delete from tbl_permissoes where id = id_param;
        
	else
		signal sqlstate '45000'
        set message_text = 'Operação inválida na procPermissoes';
	end if;
END $$
DELIMITER $$

-- ======== ROLE ========
DELIMITER $$
create procedure procRole(
	IN operacao varchar(30),
    IN role_param varchar(45),
    IN id_param int
)
BEGIN
	if operacao = 'INSERT' then
		insert into tbl_role (
			role
        ) values (
			role_param
        );
        select last_insert_id() as id;
	
    elseif operacao = 'UPDATE' then
		update tbl_role
        set role = role_param
		where id = id_param;
        select row_count() as affectedRows;
        
	elseif operacao = 'SELECT_ALL' then
		select * from tbl_role order by id desc;
        
	elseif operacao = 'SELECT_BY_ID' then
		select * from tbl_role where id = id_param;
        
	elseif operacao = 'DELETE' then
		delete from tbl_role where id = id_param;
        
	else
		signal sqlstate '45000'
        set message_text = 'Operação inválida na procRole';
	end if;
END $$
DELIMITER $$

-- ======== TIPO DOSAGEM ========
DELIMITER $$
create procedure procTipoDosagem(
	IN operacao varchar(30),
    IN tipo_dosagem_param varchar(12),
    IN id_param int
)
BEGIN
	if operacao = 'INSERT' then
		insert into tbl_tipo_dosagem (
			tipo_dosagem
        ) values (
			tipo_dosagem_param
        );
        select last_insert_id() as id;
	
    elseif operacao = 'UPDATE' then
		update tbl_tipo_dosagem
        set tipo_dosagem = tipo_dosagem_param
		where id = id_param;
        select row_count() as affectedRows;
        
	elseif operacao = 'SELECT_ALL' then
		select * from tbl_tipo_dosagem order by id desc;
        
	elseif operacao = 'SELECT_BY_ID' then
		select * from tbl_tipo_dosagem where id = id_param;
        
	elseif operacao = 'DELETE' then
		delete from tbl_tipo_dosagem where id = id_param;
        
	else
		signal sqlstate '45000'
        set message_text = 'Operação inválida na procTipoDosagem';
	end if;
END $$
DELIMITER $$

-- ======== UNIDADE MEDIDA ========
DELIMITER $$
create procedure procUnidadeMedida(
	IN operacao varchar(30),
    IN unidade_medida_param varchar(30),
    IN sigla_param varchar(6),
    IN id_param int
)
BEGIN
	if operacao = 'INSERT' then
		insert into tbl_unidade_medida (
			unidade_medida,
            sigla
        ) values (
			unidade_medida_param,
            sigla_param
        );
        select last_insert_id() as id;
	
    elseif operacao = 'UPDATE' then
		update tbl_unidade_medida
        set unidade_medida = unidade_medida_param,
			sigla = sigla_param
		where id = id_param;
        select row_count() as affectedRows;
        
	elseif operacao = 'SELECT_ALL' then
		select * from tbl_unidade_medida order by id desc;
        
	elseif operacao = 'SELECT_BY_ID' then
		select * from tbl_unidade_medida where id = id_param;
        
	elseif operacao = 'DELETE' then
		delete from tbl_unidade_medida where id = id_param;
        
	else
		signal sqlstate '45000'
        set message_text = 'Operação inválida na procUnidadeMedida';
	end if;
END $$
DELIMITER $$

-- ======== MEDICAMENTO ========
DELIMITER $$
create procedure procMedicamento(
    IN operacao varchar(30),
    IN nome_param varchar(45),
    IN imagem_param varchar(255),
    IN concentracao_param decimal(5,2),
    IN id_unidade_medida_embalagem_param int,
    IN id_tipo_dosagem_param int,
    IN id_usuario_param int,
    IN id_param int
)
BEGIN
    if operacao = 'INSERT' then
        insert into tbl_medicamentos (
            nome,
            imagem,
            concentracao,
            id_unidade_medida_embalagem,
            id_tipo_dosagem,
            id_usuario
        ) values (
            nome_param,
            imagem_param,
            concentracao_param,
            id_unidade_medida_embalagem_param,
            id_tipo_dosagem_param,
            id_usuario_param
        );

        select last_insert_id() as id;

    elseif operacao = 'UPDATE' then
        update tbl_medicamentos
        set nome = nome_param,
            imagem = imagem_param,
            concentracao = concentracao_param,
            id_unidade_medida_embalagem = id_unidade_medida_embalagem_param,
            id_tipo_dosagem = id_tipo_dosagem_param
        where id = id_param
            and id_usuario = id_usuario_param;

        select row_count() as affectedRows;

    elseif operacao = 'SELECT_ALL' then
        select
            tbl_medicamentos.id as id_medicamento,
            tbl_medicamentos.nome,
            tbl_medicamentos.imagem,
            tbl_medicamentos.concentracao,
            tbl_unidade_medida.id as id_unidade_medida_embalagem,
            tbl_unidade_medida.unidade_medida,
            tbl_unidade_medida.sigla,
            tbl_tipo_dosagem.id as id_tipo_dosagem,
            tbl_tipo_dosagem.tipo_dosagem,
            tbl_medicamentos.id_usuario
        from tbl_medicamentos
        left join tbl_unidade_medida
            on tbl_unidade_medida.id = tbl_medicamentos.id_unidade_medida_embalagem
        left join tbl_tipo_dosagem
            on tbl_tipo_dosagem.id = tbl_medicamentos.id_tipo_dosagem
        where tbl_medicamentos.id_usuario is null
            or tbl_medicamentos.id_usuario = id_usuario_param
        order by tbl_medicamentos.id desc;

    elseif operacao = 'SELECT_BY_ID' then
        select
            tbl_medicamentos.id as id_medicamento,
            tbl_medicamentos.nome,
            tbl_medicamentos.imagem,
            tbl_medicamentos.concentracao,
            tbl_unidade_medida.id as id_unidade_medida_embalagem,
            tbl_unidade_medida.unidade_medida,
            tbl_unidade_medida.sigla,
            tbl_tipo_dosagem.id as id_tipo_dosagem,
            tbl_tipo_dosagem.tipo_dosagem,
            tbl_medicamentos.id_usuario
        from tbl_medicamentos
        left join tbl_unidade_medida
            on tbl_unidade_medida.id = tbl_medicamentos.id_unidade_medida_embalagem
        left join tbl_tipo_dosagem
            on tbl_tipo_dosagem.id = tbl_medicamentos.id_tipo_dosagem
        where tbl_medicamentos.id = id_param
            and (
                tbl_medicamentos.id_usuario is null
                or tbl_medicamentos.id_usuario = id_usuario_param
            );

    elseif operacao = 'DELETE' then
        delete from tbl_medicamentos
        where id = id_param
            and id_usuario = id_usuario_param;

        select row_count() as affectedRows;

    else
        signal sqlstate '45000'
        set message_text = 'Operação inválida na procMedicamento';
    end if;
END $$
DELIMITER $$

-- ======== ESTOQUE ========
DELIMITER $$
create procedure procEstoque(
	IN operacao varchar(30),
    IN quantidade_em_estoque_param decimal(7,2),
    IN id_usuarios_param int,
    IN id_medicamentos_param int,
    IN id_param int
)
BEGIN
	if operacao = 'INSERT' then
		insert into tbl_estoque (
			quantidade_em_estoque,
            id_usuarios,
            id_medicamentos
        ) values (
			quantidade_em_estoque_param,
            id_usuarios_param,
            id_medicamentos_param
        );
        select last_insert_id() as id;
	
    elseif operacao = 'UPDATE' then
		update tbl_estoque
        set quantidade_em_estoque = quantidade_em_estoque_param,
			id_usuarios = id_usuarios_param,
            id_medicamentos = id_medicamentos_param
		where id = id_param;
        select row_count() as affectedRows;
        
	elseif operacao = 'SELECT_ALL' then
		select
			tbl_estoque.id as id_estoque, 
            tbl_estoque.quantidade_em_estoque, 
            tbl_usuarios.id as id_usuarios, 
            tbl_usuarios.nome,
			tbl_usuarios.email, 
            tbl_usuarios.cpf, 
            tbl_usuarios.data_nascimento, 
            tbl_medicamentos.id as id_medicamentos, 
            tbl_medicamentos.nome, 
            tbl_medicamentos.imagem, 
            tbl_medicamentos.concentracao,
            tbl_unidade_medida.id as id_unidade_medida_embalagem, 
            tbl_unidade_medida.unidade_medida, 
            tbl_unidade_medida.sigla,
            tbl_tipo_dosagem.id as id_tipo_dosagem,
            tbl_tipo_dosagem.tipo_dosagem
        from tbl_estoque
        left join tbl_usuarios
			on tbl_usuarios.id = tbl_estoque.id_usuarios
		left join tbl_medicamentos
			on tbl_medicamentos.id = tbl_estoque.id_medicamentos
		left join tbl_unidade_medida
			on tbl_unidade_medida.id = tbl_medicamentos.id_unidade_medida_embalagem
		left join tbl_tipo_dosagem
			on tbl_tipo_dosagem.id = tbl_medicamentos.id_tipo_dosagem
        order by tbl_estoque.id desc;
        
	elseif operacao = 'SELECT_BY_ID' then
		select
			tbl_estoque.id as id_estoque, 
            tbl_estoque.quantidade_em_estoque, 
            tbl_usuarios.id as id_usuarios, 
            tbl_usuarios.nome,
			tbl_usuarios.email, 
            tbl_usuarios.cpf, 
            tbl_usuarios.data_nascimento, 
            tbl_medicamentos.id as id_medicamento, 
            tbl_medicamentos.nome, 
            tbl_medicamentos.imagem, 
            tbl_medicamentos.concentracao,
            tbl_unidade_medida.id as id_unidade_medida_embalagem, 
            tbl_unidade_medida.unidade_medida, 
            tbl_unidade_medida.sigla,
            tbl_tipo_dosagem.id as id_tipo_dosagem,
            tbl_tipo_dosagem.tipo_dosagem
        from tbl_estoque
        left join tbl_usuarios
			on tbl_usuarios.id = tbl_estoque.id_usuarios
		left join tbl_medicamentos
			on tbl_medicamentos.id = tbl_estoque.id_medicamentos
		left join tbl_unidade_medida
			on tbl_unidade_medida.id = tbl_medicamentos.id_unidade_medida_embalagem
		left join tbl_tipo_dosagem
			on tbl_tipo_dosagem.id = tbl_medicamentos.id_tipo_dosagem
        where tbl_estoque.id = id_param;
        
	elseif operacao = 'DESCONTAR' then
        update tbl_estoque
        set quantidade_em_estoque = quantidade_em_estoque - quantidade_em_estoque_param
        where id = id_param
            and quantidade_em_estoque >= quantidade_em_estoque_param
            and quantidade_em_estoque_param > 0;

        select row_count() as affectedRows;
        
	elseif operacao = 'SELECT_BY_USUARIO_MEDICAMENTO' then
        select
            tbl_estoque.id as id_estoque,
            tbl_estoque.quantidade_em_estoque,
            tbl_estoque.id_usuarios,
            tbl_estoque.id_medicamentos
        from tbl_estoque
        where tbl_estoque.id_usuarios = id_usuarios_param
            and tbl_estoque.id_medicamentos = id_medicamentos_param;

    elseif operacao = 'SELECT_BY_ID_USUARIO' then
        select
            tbl_estoque.id as id_estoque,
            tbl_estoque.quantidade_em_estoque,
            tbl_usuarios.id as id_usuarios,
            tbl_usuarios.nome as nome_usuario,
            tbl_medicamentos.id as id_medicamento,
            tbl_medicamentos.nome as nome_medicamento,
            tbl_medicamentos.imagem,
            tbl_medicamentos.concentracao,
            tbl_unidade_medida.id as id_unidade_medida_embalagem,
            tbl_unidade_medida.unidade_medida,
            tbl_unidade_medida.sigla,
            tbl_tipo_dosagem.id as id_tipo_dosagem,
            tbl_tipo_dosagem.tipo_dosagem
        from tbl_estoque
        left join tbl_usuarios
            on tbl_usuarios.id = tbl_estoque.id_usuarios
        left join tbl_medicamentos
            on tbl_medicamentos.id = tbl_estoque.id_medicamentos
        left join tbl_unidade_medida
            on tbl_unidade_medida.id = tbl_medicamentos.id_unidade_medida_embalagem
        left join tbl_tipo_dosagem
            on tbl_tipo_dosagem.id = tbl_medicamentos.id_tipo_dosagem
        where tbl_estoque.id_usuarios = id_usuarios_param
        order by tbl_estoque.id desc;
        
	elseif operacao = 'DELETE' then
		delete from tbl_estoque where id = id_param;
        select row_count() as affectedRows;
        
	else
		signal sqlstate '45000'
        set message_text = 'Operação inválida na procEstoque';
	end if;
END $$
DELIMITER $$

-- ======== HISTORICO MEDICAMENTO ========
DELIMITER $$
create procedure procHistoricoMedicamento(
    IN operacao varchar(30),
    IN hora_ingestao_param datetime,
    IN id_paciente_param int,
    IN id_receita_medica_param int,
    IN dosagem_ingerida_param decimal(5,2),
    IN horario_programado_param datetime,
    IN nome_medicamento_param varchar(45),
    IN concentracao_param decimal(5,2),
    IN unidade_concentracao_param varchar(6),
    IN tipo_dosagem_param varchar(12),
    IN id_param int
)
BEGIN
    if operacao = 'INSERT' then
        insert into tbl_historico_medicamento (
            hora_ingestao,
            id_paciente,
            id_receita_medica,
            dosagem_ingerida,
            horario_programado,
            nome_medicamento,
            concentracao,
            unidade_concentracao,
            tipo_dosagem
        ) values (
            hora_ingestao_param,
            id_paciente_param,
            id_receita_medica_param,
            dosagem_ingerida_param,
            horario_programado_param,
            nome_medicamento_param,
            concentracao_param,
            unidade_concentracao_param,
            tipo_dosagem_param
        );

        select last_insert_id() as id;

    elseif operacao = 'UPDATE' then
        update tbl_historico_medicamento
        set hora_ingestao = hora_ingestao_param,
            id_paciente = id_paciente_param,
            id_receita_medica = id_receita_medica_param,
            dosagem_ingerida = dosagem_ingerida_param,
            horario_programado = horario_programado_param,
            nome_medicamento = nome_medicamento_param,
            concentracao = concentracao_param,
            unidade_concentracao = unidade_concentracao_param,
            tipo_dosagem = tipo_dosagem_param
        where id = id_param;

        select row_count() as affectedRows;

    elseif operacao = 'SELECT_ALL' then
        select
            tbl_historico_medicamento.id as id_historico_medicamento,
            tbl_historico_medicamento.hora_ingestao,
            tbl_historico_medicamento.id_paciente,
            tbl_usuarios.nome as nome_paciente,
            tbl_historico_medicamento.id_receita_medica,
            tbl_historico_medicamento.dosagem_ingerida,
            tbl_historico_medicamento.horario_programado,
            tbl_historico_medicamento.nome_medicamento,
            tbl_historico_medicamento.concentracao,
            tbl_historico_medicamento.unidade_concentracao,
            tbl_historico_medicamento.tipo_dosagem
        from tbl_historico_medicamento
        inner join tbl_usuarios
            on tbl_usuarios.id = tbl_historico_medicamento.id_paciente;

    elseif operacao = 'SELECT_BY_ID' then
        select
            tbl_historico_medicamento.id as id_historico_medicamento,
            tbl_historico_medicamento.hora_ingestao,
            tbl_historico_medicamento.id_paciente,
            tbl_usuarios.nome as nome_paciente,
            tbl_historico_medicamento.id_receita_medica,
            tbl_historico_medicamento.dosagem_ingerida,
            tbl_historico_medicamento.horario_programado,
            tbl_historico_medicamento.nome_medicamento,
            tbl_historico_medicamento.concentracao,
            tbl_historico_medicamento.unidade_concentracao,
            tbl_historico_medicamento.tipo_dosagem
        from tbl_historico_medicamento
        inner join tbl_usuarios
            on tbl_usuarios.id = tbl_historico_medicamento.id_paciente
        where tbl_historico_medicamento.id = id_param;

    elseif operacao = 'SELECT_BY_ID_RECEITA' then
        select
            tbl_historico_medicamento.id as id_historico_medicamento,
            tbl_historico_medicamento.hora_ingestao,
            tbl_historico_medicamento.id_paciente,
            tbl_usuarios.nome as nome_paciente,
            tbl_historico_medicamento.id_receita_medica,
            tbl_historico_medicamento.dosagem_ingerida,
            tbl_historico_medicamento.horario_programado,
            tbl_historico_medicamento.nome_medicamento,
            tbl_historico_medicamento.concentracao,
            tbl_historico_medicamento.unidade_concentracao,
            tbl_historico_medicamento.tipo_dosagem
        from tbl_historico_medicamento
        inner join tbl_usuarios
            on tbl_usuarios.id = tbl_historico_medicamento.id_paciente
        where tbl_historico_medicamento.id_receita_medica = id_receita_medica_param;
        
	elseif operacao = 'SELECT_BY_ID_PACIENTE' then
		select
			tbl_historico_medicamento.id as id_historico_medicamento,
			tbl_historico_medicamento.hora_ingestao,
			tbl_historico_medicamento.id_paciente,
			tbl_usuarios.nome as nome_paciente,
			tbl_historico_medicamento.id_receita_medica,
			tbl_historico_medicamento.dosagem_ingerida,
			tbl_historico_medicamento.horario_programado,
			tbl_historico_medicamento.nome_medicamento,
			tbl_historico_medicamento.concentracao,
			tbl_historico_medicamento.unidade_concentracao,
			tbl_historico_medicamento.tipo_dosagem
		from tbl_historico_medicamento
		inner join tbl_usuarios
			on tbl_usuarios.id = tbl_historico_medicamento.id_paciente
		where tbl_historico_medicamento.id_paciente = id_paciente_param
		order by tbl_historico_medicamento.hora_ingestao desc;

    elseif operacao = 'DELETE' then
        delete from tbl_historico_medicamento
        where id = id_param;

        select row_count() as affectedRows;
	
    else
        signal sqlstate '45000'
        set message_text = 'Operação inválida na procHistoricoMedicamento';
    end if;
END $$
DELIMITER $$

select * from tbl_historico_medicamento;

select
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
from information_schema.KEY_COLUMN_USAGE
where TABLE_SCHEMA = 'db_medtime'
    and REFERENCED_TABLE_NAME is not null
order by TABLE_NAME;

use db_medtime;

-- ======== USUARIOS ========
DELIMITER $$
create procedure procUsuario(
    IN operacao varchar(30),
    IN nome_param varchar(45),
    IN foto_param varchar(500),
    IN email_param varchar(255),
    IN senha_param varchar(512),
    IN cpf_param varchar(20),
    IN telefone_param varchar(20),
    IN data_nascimento_param date,
    IN id_param int
)
BEGIN
    if operacao = 'INSERT' then
        insert into tbl_usuarios (
            nome,
            foto,
            email,
            senha,
            cpf,
            telefone,
            data_nascimento
        ) values (
            nome_param,
            foto_param,
            email_param,
            senha_param,
            cpf_param,
            telefone_param,
            data_nascimento_param
        );
        select last_insert_id() as id;

    elseif operacao = 'UPDATE' then
        update tbl_usuarios
        set nome = nome_param,
            foto = foto_param,
            email = email_param,
            senha = senha_param,
            cpf = cpf_param,
            telefone = telefone_param,
            data_nascimento = data_nascimento_param
        where id = id_param;
        select row_count() as affectedRows;

    elseif operacao = 'SELECT_ALL' then
        select
            id,
            nome,
            foto,
            email,
            cpf,
            telefone,
            data_nascimento,
            ativo,
            email_verificado
        from tbl_usuarios
        order by id desc;

    elseif operacao = 'SELECT_BY_ID' then
        select
            id,
            nome,
            foto,
            email,
            cpf,
            telefone,
            data_nascimento,
            ativo,
            email_verificado
        from tbl_usuarios
        where id = id_param;

    elseif operacao = 'SELECT_BY_EMAIL' then
        select * from tbl_usuarios where email = email_param;

    elseif operacao = 'SELECT_DADOS_USUARIOS' then
        select * from vw_dados_usuarios;

    elseif operacao = 'VERIFICAR_EMAIL' then
        update tbl_usuarios
        set email_verificado = true
        where id = id_param
            and email_verificado = false;

        select row_count() as affectedRows;
        
	elseif operacao = 'UPDATE_SENHA' then
		update tbl_usuarios
		set senha = senha_param
		where id = id_param;

		select row_count() as affectedRows;

    elseif operacao = 'DELETE' then
        delete from tbl_usuarios where id = id_param;
        select row_count() as affectedRows;

    else
        signal sqlstate '45000'
        set message_text = 'Operação inválida na procUsuario';
    end if;
END $$
DELIMITER $$

-- ======== ROLE PERMISSOES ========
DELIMITER $$
create procedure procRolePermissoes(
    IN operacao varchar(30),
    IN id_role_param int,
    IN id_permissoes_param int,
    IN id_param int
)
BEGIN
    if operacao = 'INSERT' then
        insert into tbl_role_permissoes (
            id_role,
            id_permissoes
        ) values (
            id_role_param,
            id_permissoes_param
        );
        select last_insert_id() as id;

    elseif operacao = 'UPDATE' then
        update tbl_role_permissoes
        set id_role = id_role_param,
            id_permissoes = id_permissoes_param
        where id = id_param;
        select row_count() as affectedRows;

    elseif operacao = 'SELECT_ALL' then
        select
            tbl_role_permissoes.id as id_role_permissoes,
            tbl_role.id as id_role,
            tbl_role.role,
            tbl_permissoes.id as id_permissoes,
            tbl_permissoes.permissao
        from tbl_role_permissoes
        left join tbl_role
            on tbl_role.id = tbl_role_permissoes.id_role
        left join tbl_permissoes
            on tbl_permissoes.id = tbl_role_permissoes.id_permissoes
        order by tbl_role_permissoes.id desc;

    elseif operacao = 'SELECT_BY_ID' then
        select
            tbl_role_permissoes.id as id_role_permissoes,
            tbl_role.id as id_role,
            tbl_role.role,
            tbl_permissoes.id as id_permissoes,
            tbl_permissoes.permissao
        from tbl_role_permissoes
        left join tbl_role
            on tbl_role.id = tbl_role_permissoes.id_role
        left join tbl_permissoes
            on tbl_permissoes.id = tbl_role_permissoes.id_permissoes
        where tbl_role_permissoes.id = id_param;

    elseif operacao = 'DELETE' then
        delete from tbl_role_permissoes where id = id_param;
        select row_count() as affectedRows;

    else
        signal sqlstate '45000'
        set message_text = 'Operação inválida na procRolePermissoes';
    end if;
END $$
DELIMITER $$

-- ======== USUARIOS ROLE ========
DELIMITER $$
create procedure procUsuariosRole(
    IN operacao varchar(30),
    IN ativo_param tinyint,
    IN data_ativacao_param datetime,
    IN data_desativacao_param datetime,
    IN id_usuarios_param int,
    IN id_role_param int,
    IN id_param int
)
BEGIN
    if operacao = 'INSERT' then
        insert into tbl_usuarios_role (
            ativo,
            data_ativacao,
            data_desativacao,
            id_usuarios,
            id_role
        ) values (
            ativo_param,
            data_ativacao_param,
            data_desativacao_param,
            id_usuarios_param,
            id_role_param
        );
        select last_insert_id() as id;

    elseif operacao = 'UPDATE' then
        update tbl_usuarios_role
        set ativo = ativo_param,
            data_ativacao = data_ativacao_param,
            data_desativacao = data_desativacao_param,
            id_usuarios = id_usuarios_param,
            id_role = id_role_param
        where id = id_param;
        select row_count() as affectedRows;

    elseif operacao = 'SELECT_ALL' then
        select
            tbl_usuarios_role.id as id_usuarios_role,
            tbl_usuarios_role.ativo,
            tbl_usuarios_role.data_ativacao,
            tbl_usuarios_role.data_desativacao,
            tbl_usuarios.id as id_usuario,
            tbl_usuarios.nome as nome_usuario,
            tbl_usuarios.email,
            tbl_usuarios.cpf,
            tbl_usuarios.data_nascimento,
            tbl_role.id as id_role,
            tbl_role.role
        from tbl_usuarios_role
        left join tbl_usuarios
            on tbl_usuarios.id = tbl_usuarios_role.id_usuarios
        left join tbl_role
            on tbl_role.id = tbl_usuarios_role.id_role
        order by tbl_usuarios_role.id desc;

    elseif operacao = 'SELECT_BY_ID' then
        select
            tbl_usuarios_role.id as id_usuarios_role,
            tbl_usuarios_role.ativo,
            tbl_usuarios_role.data_ativacao,
            tbl_usuarios_role.data_desativacao,
            tbl_usuarios.id as id_usuario,
            tbl_usuarios.nome as nome_usuario,
            tbl_usuarios.email,
            tbl_usuarios.cpf,
            tbl_usuarios.data_nascimento,
            tbl_role.id as id_role,
            tbl_role.role
        from tbl_usuarios_role
        left join tbl_usuarios
            on tbl_usuarios.id = tbl_usuarios_role.id_usuarios
        left join tbl_role
            on tbl_role.id = tbl_usuarios_role.id_role
        where tbl_usuarios_role.id = id_param;

    elseif operacao = 'DELETE' then
        delete from tbl_usuarios_role where id = id_param;
        select row_count() as affectedRows;

    else
        signal sqlstate '45000'
        set message_text = 'Operação inválida na procUsuariosRole';
    end if;
END $$
DELIMITER $$

-- ======== VINCULO PACIENTE ========
DELIMITER $$
create procedure procVinculoPaciente(
    IN operacao varchar(30),
    IN data_vinculo_param datetime,
    IN id_paciente_param int,
    IN id_cuidador_param int,
    IN id_param int
)
BEGIN
    if operacao = 'INSERT' then
        insert into tbl_vinculo_paciente (
            data_vinculo,
            id_paciente,
            id_cuidador
        ) values (
            now(),
            id_paciente_param,
            id_cuidador_param
        );
        select last_insert_id() as id;

    elseif operacao = 'UPDATE' then
        update tbl_vinculo_paciente
        set data_vinculo = data_vinculo_param,
            id_paciente = id_paciente_param,
            id_cuidador = id_cuidador_param
        where id = id_param;
        select row_count() as affectedRows;

    elseif operacao = 'SELECT_ALL' then
        select
            tbl_vinculo_paciente.id as id_vinculo_paciente,
            tbl_vinculo_paciente.data_vinculo,
            tbl_vinculo_paciente.id_paciente,
            tbl_usuarios_paciente.nome as nome_paciente,
            tbl_usuarios_paciente.email as email_paciente,
            tbl_usuarios_paciente.cpf as cpf_paciente,
            tbl_usuarios_paciente.data_nascimento as data_nascimento_paciente,
            tbl_vinculo_paciente.id_cuidador,
            tbl_usuarios_cuidador.nome as nome_cuidador,
            tbl_usuarios_cuidador.email as email_cuidador,
            tbl_usuarios_cuidador.cpf as cpf_cuidador,
            tbl_usuarios_cuidador.data_nascimento as data_nascimento_cuidador
        from tbl_vinculo_paciente
        left join tbl_usuarios as tbl_usuarios_paciente
            on tbl_usuarios_paciente.id = tbl_vinculo_paciente.id_paciente
        left join tbl_usuarios as tbl_usuarios_cuidador
            on tbl_usuarios_cuidador.id = tbl_vinculo_paciente.id_cuidador
        order by tbl_vinculo_paciente.id desc;

    elseif operacao = 'SELECT_BY_ID' then
        select
            tbl_vinculo_paciente.id as id_vinculo_paciente,
            tbl_vinculo_paciente.data_vinculo,
            tbl_vinculo_paciente.id_paciente,
            tbl_usuarios_paciente.nome as nome_paciente,
            tbl_usuarios_paciente.email as email_paciente,
            tbl_usuarios_paciente.cpf as cpf_paciente,
            tbl_usuarios_paciente.data_nascimento as data_nascimento_paciente,
            tbl_vinculo_paciente.id_cuidador,
            tbl_usuarios_cuidador.nome as nome_cuidador,
            tbl_usuarios_cuidador.email as email_cuidador,
            tbl_usuarios_cuidador.cpf as cpf_cuidador,
            tbl_usuarios_cuidador.data_nascimento as data_nascimento_cuidador
        from tbl_vinculo_paciente
        left join tbl_usuarios as tbl_usuarios_paciente
            on tbl_usuarios_paciente.id = tbl_vinculo_paciente.id_paciente
        left join tbl_usuarios as tbl_usuarios_cuidador
            on tbl_usuarios_cuidador.id = tbl_vinculo_paciente.id_cuidador
        where tbl_vinculo_paciente.id = id_param;

    elseif operacao = 'SELECT_BY_ID_PACIENTE' then
        select
            tbl_vinculo_paciente.*,
            tbl_usuarios.nome,
            tbl_usuarios.foto,
            tbl_usuarios.email,
            tbl_usuarios.telefone,
            tbl_usuarios.data_nascimento
        from tbl_vinculo_paciente
            inner join tbl_usuarios
                on tbl_usuarios.id = tbl_vinculo_paciente.id_cuidador
        where tbl_vinculo_paciente.id_paciente = id_paciente_param;

    elseif operacao = 'SELECT_BY_ID_CUIDADOR' then
        select
            tbl_vinculo_paciente.*,
            tbl_usuarios.nome,
            tbl_usuarios.foto,
            tbl_usuarios.email,
            tbl_usuarios.cpf,
            tbl_usuarios.telefone,
            tbl_usuarios.data_nascimento,
            tbl_usuarios.ativo,
            tbl_usuarios.email_verificado,

            (
                select coalesce(
                    json_arrayagg(
                        json_object(
                            'id', tbl_contato_de_emergencia.id,
                            'nome', tbl_contato_de_emergencia.nome,
                            'telefone', tbl_contato_de_emergencia.telefone
                        )
                    ),
                    json_array()
                )
                from tbl_contato_emergencia_usuarios
                    inner join tbl_contato_de_emergencia
                        on tbl_contato_de_emergencia.id =
                        tbl_contato_emergencia_usuarios.id_contato_de_emergencia
                where tbl_contato_emergencia_usuarios.id_usuarios =
                    tbl_usuarios.id
            ) as contatos_emergencia,

            (
                select coalesce(
                    json_arrayagg(
                        json_object(
                            'id', tbl_doencas_cronicas.id,
                            'nome_doenca', tbl_doencas_cronicas.nome_doenca
                        )
                    ),
                    json_array()
                )
                from tbl_doenca_cronica_usuario
                    inner join tbl_doencas_cronicas
                        on tbl_doencas_cronicas.id =
                        tbl_doenca_cronica_usuario.id_doencas_cronicas
                where tbl_doenca_cronica_usuario.id_usuarios =
                    tbl_usuarios.id
            ) as doencas_cronicas

        from tbl_vinculo_paciente
            inner join tbl_usuarios
                on tbl_usuarios.id = tbl_vinculo_paciente.id_paciente
        where tbl_vinculo_paciente.id_cuidador = id_cuidador_param
        order by tbl_vinculo_paciente.data_vinculo desc;

    elseif operacao = 'DELETE' then
        delete from tbl_vinculo_paciente where id = id_param;
        select row_count() as affectedRows;

    else
        signal sqlstate '45000'
        set message_text = 'Operação inválida na procVinculoPaciente';
    end if;
END $$
DELIMITER $$

-- ======== CODIGO DE VERIFICACAO ========
DELIMITER $$

create procedure procCodigoVerificacao(
    IN operacao varchar(40),
    IN codigo_hash_param varchar(255),
    IN tipo_param varchar(30),
    IN id_usuario_param int,
    IN email_param varchar(255),
    IN data_expiracao_param datetime,
    IN utilizado_param boolean,
    IN tentativas_param int,
    IN id_param int
)
BEGIN
    if operacao = 'INSERT' then
        insert into tbl_codigos_verificacao (
            codigo_hash,
            tipo,
            id_usuario,
            email,
            data_expiracao,
            utilizado,
            tentativas
        ) values (
            codigo_hash_param,
            tipo_param,
            id_usuario_param,
            email_param,
            data_expiracao_param,
            false,
            0
        );

        select last_insert_id() as id;

    elseif operacao = 'UPDATE' then
        update tbl_codigos_verificacao
        set codigo_hash = codigo_hash_param,
            tipo = tipo_param,
            id_usuario = id_usuario_param,
            email = email_param,
            data_expiracao = data_expiracao_param,
            utilizado = utilizado_param,
            tentativas = tentativas_param
        where id = id_param;

        select row_count() as affectedRows;

    elseif operacao = 'SELECT_ALL' then
        select
            tbl_codigos_verificacao.*
        from tbl_codigos_verificacao;

    elseif operacao = 'SELECT_BY_ID' then
        select
            tbl_codigos_verificacao.*
        from tbl_codigos_verificacao
        where id = id_param;

    elseif operacao = 'SELECT_BY_USUARIO_TIPO' then
        select
            tbl_codigos_verificacao.*
        from tbl_codigos_verificacao
        where id_usuario = id_usuario_param
            and tipo = tipo_param
        order by id desc;

    elseif operacao = 'SELECT_BY_HASH_TIPO' then
        select
            tbl_codigos_verificacao.*
        from tbl_codigos_verificacao
        where codigo_hash = codigo_hash_param
            and tipo = tipo_param
        order by id desc
        limit 1;

    elseif operacao = 'SELECT_BY_HASH_TIPO_BLOQUEADO' then
        select
            tbl_codigos_verificacao.*
        from tbl_codigos_verificacao
        where codigo_hash = codigo_hash_param
            and tipo = tipo_param
        order by id desc
        limit 1
        for update;

    elseif operacao = 'SELECT_BY_EMAIL_TIPO' then
        select
            tbl_codigos_verificacao.*
        from tbl_codigos_verificacao
        where email = email_param
            and tipo = tipo_param
        order by id desc;

    elseif operacao = 'SELECT_BY_EMAIL_TIPO_BLOQUEADO' then
        select
            tbl_codigos_verificacao.*
        from tbl_codigos_verificacao
        where email = email_param
            and tipo = tipo_param
        order by id desc
        limit 1
        for update;

    elseif operacao = 'DELETE' then
        delete from tbl_codigos_verificacao
        where id = id_param;

        select row_count() as affectedRows;

    else
        signal sqlstate '45000'
        set message_text = 'Operação inválida na procCodigoVerificacao';
    end if;
END $$
DELIMITER $$

-- ======== RECEITA MEDICA ========
DELIMITER $$
create procedure procReceitaMedica(
    IN operacao varchar(30),
    IN id_usuario_param int,
    IN id_medicamento_param int,
    IN dosagem_param decimal(5,2),
    IN id_unidade_medida_param int,
    IN id_estoque_param int,
    IN descricao_param text,
    IN id_param int
)
BEGIN
    if operacao = 'INSERT' then
        insert into tbl_receita_medica (
            id_usuario,
            id_medicamento,
            dosagem,
            id_unidade_medida,
            id_estoque,
            descricao
        ) values (
            id_usuario_param,
            id_medicamento_param,
            dosagem_param,
            id_unidade_medida_param,
            id_estoque_param,
            descricao_param
        );

        select last_insert_id() as id;

    elseif operacao = 'UPDATE' then
        update tbl_receita_medica
        set id_usuario = id_usuario_param,
            id_medicamento = id_medicamento_param,
            dosagem = dosagem_param,
            id_unidade_medida = id_unidade_medida_param,
            id_estoque = id_estoque_param,
            descricao = descricao_param
        where id = id_param;

        select row_count() as affectedRows;

    elseif operacao = 'SELECT_ALL' then
        select
            tbl_receita_medica.id as id_receita_medica,
            tbl_receita_medica.dosagem,
            tbl_receita_medica.descricao,
            tbl_receita_medica.id_estoque,
            tbl_estoque.quantidade_em_estoque,
            tbl_usuarios.id as id_usuario,
            tbl_usuarios.nome as nome_usuario,
            tbl_usuarios.email,
            tbl_usuarios.cpf,
            tbl_usuarios.data_nascimento,
            tbl_medicamentos.id as id_medicamento,
            tbl_medicamentos.nome as nome_medicamento,
            tbl_medicamentos.imagem,
            tbl_medicamentos.concentracao,
            tbl_unidade_medida_embalagem.id as id_unidade_medida_embalagem,
            tbl_unidade_medida_embalagem.unidade_medida as unidade_medida_embalagem,
            tbl_unidade_medida_embalagem.sigla as sigla_embalagem,
            tbl_tipo_dosagem.id as id_tipo_dosagem,
            tbl_tipo_dosagem.tipo_dosagem,
            tbl_unidade_medida_dose.id as id_unidade_medida,
            tbl_unidade_medida_dose.unidade_medida as unidade_medida_dose,
            tbl_unidade_medida_dose.sigla as sigla_dose
        from tbl_receita_medica
        left join tbl_usuarios
            on tbl_usuarios.id = tbl_receita_medica.id_usuario
        left join tbl_medicamentos
            on tbl_medicamentos.id = tbl_receita_medica.id_medicamento
        left join tbl_estoque
            on tbl_estoque.id = tbl_receita_medica.id_estoque
        left join tbl_unidade_medida as tbl_unidade_medida_embalagem
            on tbl_unidade_medida_embalagem.id = tbl_medicamentos.id_unidade_medida_embalagem
        left join tbl_tipo_dosagem
            on tbl_tipo_dosagem.id = tbl_medicamentos.id_tipo_dosagem
        left join tbl_unidade_medida as tbl_unidade_medida_dose
            on tbl_unidade_medida_dose.id = tbl_receita_medica.id_unidade_medida
        where tbl_receita_medica.id_usuario = id_usuario_param
        order by tbl_receita_medica.id desc;

    elseif operacao = 'SELECT_BY_ID' then
        select
            tbl_receita_medica.id as id_receita_medica,
            tbl_receita_medica.dosagem,
            tbl_receita_medica.descricao,
            tbl_receita_medica.id_estoque,
            tbl_estoque.quantidade_em_estoque,
            tbl_usuarios.id as id_usuario,
            tbl_usuarios.nome as nome_usuario,
            tbl_usuarios.email,
            tbl_usuarios.cpf,
            tbl_usuarios.data_nascimento,
            tbl_medicamentos.id as id_medicamento,
            tbl_medicamentos.nome as nome_medicamento,
            tbl_medicamentos.imagem,
            tbl_medicamentos.concentracao,
            tbl_medicamentos.id_usuario as id_usuario_medicamento,
            tbl_unidade_medida_embalagem.id as id_unidade_medida_embalagem,
            tbl_unidade_medida_embalagem.unidade_medida as unidade_medida_embalagem,
            tbl_unidade_medida_embalagem.sigla as sigla_embalagem,
            tbl_tipo_dosagem.id as id_tipo_dosagem,
            tbl_tipo_dosagem.tipo_dosagem,
            tbl_unidade_medida_dose.id as id_unidade_medida,
            tbl_unidade_medida_dose.unidade_medida as unidade_medida_dose,
            tbl_unidade_medida_dose.sigla as sigla_dose
        from tbl_receita_medica
        left join tbl_usuarios
            on tbl_usuarios.id = tbl_receita_medica.id_usuario
        left join tbl_medicamentos
            on tbl_medicamentos.id = tbl_receita_medica.id_medicamento
        left join tbl_estoque
            on tbl_estoque.id = tbl_receita_medica.id_estoque
        left join tbl_unidade_medida as tbl_unidade_medida_embalagem
            on tbl_unidade_medida_embalagem.id = tbl_medicamentos.id_unidade_medida_embalagem
        left join tbl_tipo_dosagem
            on tbl_tipo_dosagem.id = tbl_medicamentos.id_tipo_dosagem
        left join tbl_unidade_medida as tbl_unidade_medida_dose
            on tbl_unidade_medida_dose.id = tbl_receita_medica.id_unidade_medida
        where tbl_receita_medica.id = id_param;

    elseif operacao = 'DELETE' then
        delete from tbl_receita_medica
        where id = id_param;

        select row_count() as affectedRows;

    else
        signal sqlstate '45000'
        set message_text = 'Operação inválida na procReceitaMedica';
    end if;
END $$
DELIMITER $$


-- ======== PROGRAMACAO MEDICAMENTO ========
DELIMITER $$
create procedure procProgramacaoMedicamento(
    IN operacao varchar(30),
    IN frequencia_param int,
    IN data_hora_inicio_param datetime,
    IN data_hora_fim_param datetime,
    IN id_tipo_intervalo_param int,
    IN id_receita_medica_param int,
    IN id_param int
)
BEGIN
    if operacao = 'INSERT' then
        insert into tbl_programacao_medicamento (
            frequencia,
            data_hora_inicio,
            data_hora_fim,
            id_tipo_intervalo,
            id_receita_medica
        ) values (
            frequencia_param,
            data_hora_inicio_param,
            data_hora_fim_param,
            id_tipo_intervalo_param,
            id_receita_medica_param
        );

        select last_insert_id() as id;

    elseif operacao = 'UPDATE' then
		update tbl_programacao_medicamento
		set data_hora_fim = data_hora_fim_param
		where id = id_param
			and data_hora_fim is null
			and data_hora_inicio < data_hora_fim_param;

		select row_count() as affectedRows;
        
	elseif operacao = 'UPDATE_DADOS' then
		update tbl_programacao_medicamento
		set
			frequencia = frequencia_param,
			data_hora_inicio = data_hora_inicio_param,
			id_tipo_intervalo = id_tipo_intervalo_param
		where id = id_param
			and data_hora_fim is null
			and data_hora_inicio > utc_timestamp();

		select row_count() as affectedRows;
        
	elseif operacao = 'UPDATE_FIM' then
		update tbl_programacao_medicamento
		set data_hora_fim = data_hora_fim_param
		where id = id_param
			and data_hora_fim is not null
			and data_hora_inicio < data_hora_fim_param;

		select row_count() as affectedRows;

    elseif operacao = 'SELECT_ALL' then
        select
            tbl_programacao_medicamento.id as id_programacao_medicamento,
            tbl_programacao_medicamento.frequencia,
            tbl_programacao_medicamento.data_hora_inicio,
            tbl_programacao_medicamento.data_hora_fim,
            tbl_tipo_intervalo.id as id_tipo_intervalo,
            tbl_tipo_intervalo.tipo_intervalo,
            tbl_receita_medica.id as id_receita_medica,
            tbl_receita_medica.dosagem,
            tbl_receita_medica.descricao,
            tbl_usuarios.id as id_usuario,
            tbl_usuarios.nome as nome_usuario,
            tbl_medicamentos.id as id_medicamento,
            tbl_medicamentos.nome as nome_medicamento
        from tbl_programacao_medicamento
        inner join tbl_tipo_intervalo
            on tbl_tipo_intervalo.id = tbl_programacao_medicamento.id_tipo_intervalo
        inner join tbl_receita_medica
            on tbl_receita_medica.id = tbl_programacao_medicamento.id_receita_medica
        inner join tbl_usuarios
            on tbl_usuarios.id = tbl_receita_medica.id_usuario
        inner join tbl_medicamentos
            on tbl_medicamentos.id = tbl_receita_medica.id_medicamento;

    elseif operacao = 'SELECT_BY_ID' then
        select
            tbl_programacao_medicamento.id as id_programacao_medicamento,
            tbl_programacao_medicamento.frequencia,
            tbl_programacao_medicamento.data_hora_inicio,
            tbl_programacao_medicamento.data_hora_fim,
            tbl_tipo_intervalo.id as id_tipo_intervalo,
            tbl_tipo_intervalo.tipo_intervalo,
            tbl_receita_medica.id as id_receita_medica,
            tbl_receita_medica.dosagem,
            tbl_receita_medica.descricao,
            tbl_usuarios.id as id_usuario,
            tbl_usuarios.nome as nome_usuario,
            tbl_medicamentos.id as id_medicamento,
            tbl_medicamentos.nome as nome_medicamento
        from tbl_programacao_medicamento
        inner join tbl_tipo_intervalo
            on tbl_tipo_intervalo.id = tbl_programacao_medicamento.id_tipo_intervalo
        inner join tbl_receita_medica
            on tbl_receita_medica.id = tbl_programacao_medicamento.id_receita_medica
        inner join tbl_usuarios
            on tbl_usuarios.id = tbl_receita_medica.id_usuario
        inner join tbl_medicamentos
            on tbl_medicamentos.id = tbl_receita_medica.id_medicamento
        where tbl_programacao_medicamento.id = id_param;
        
	elseif operacao = 'SELECT_BY_ID_RECEITA' then
		select
			tbl_programacao_medicamento.id as id_programacao_medicamento,
			tbl_programacao_medicamento.frequencia,
			tbl_programacao_medicamento.data_hora_inicio,
			tbl_programacao_medicamento.data_hora_fim,
			tbl_tipo_intervalo.id as id_tipo_intervalo,
			tbl_tipo_intervalo.tipo_intervalo,
			tbl_receita_medica.id as id_receita_medica,
			tbl_receita_medica.dosagem,
			tbl_receita_medica.descricao,
			tbl_usuarios.id as id_usuario,
			tbl_usuarios.nome as nome_usuario,
			tbl_medicamentos.id as id_medicamento,
			tbl_medicamentos.nome as nome_medicamento
		from tbl_programacao_medicamento
		inner join tbl_tipo_intervalo
			on tbl_tipo_intervalo.id = tbl_programacao_medicamento.id_tipo_intervalo
		inner join tbl_receita_medica
			on tbl_receita_medica.id = tbl_programacao_medicamento.id_receita_medica
		inner join tbl_usuarios
			on tbl_usuarios.id = tbl_receita_medica.id_usuario
		inner join tbl_medicamentos
			on tbl_medicamentos.id = tbl_receita_medica.id_medicamento
		where tbl_programacao_medicamento.id_receita_medica = id_receita_medica_param
		order by tbl_programacao_medicamento.data_hora_inicio desc;
        
	
	elseif operacao = 'SELECT_BY_ID_USUARIO' then
		select
			tbl_programacao_medicamento.id as id_programacao_medicamento,
			tbl_programacao_medicamento.frequencia,
			tbl_programacao_medicamento.data_hora_inicio,
			tbl_programacao_medicamento.data_hora_fim,
			tbl_tipo_intervalo.id as id_tipo_intervalo,
			tbl_tipo_intervalo.tipo_intervalo,
			tbl_receita_medica.id as id_receita_medica,
			tbl_receita_medica.dosagem,
			tbl_receita_medica.descricao,
			tbl_usuarios.id as id_usuario,
			tbl_usuarios.nome as nome_usuario,
			tbl_medicamentos.id as id_medicamento,
			tbl_medicamentos.nome as nome_medicamento,
            tbl_tipo_dosagem.tipo_dosagem
		from tbl_programacao_medicamento
		inner join tbl_tipo_intervalo
			on tbl_tipo_intervalo.id = tbl_programacao_medicamento.id_tipo_intervalo
		inner join tbl_receita_medica
			on tbl_receita_medica.id = tbl_programacao_medicamento.id_receita_medica
		inner join tbl_usuarios
			on tbl_usuarios.id = tbl_receita_medica.id_usuario
		inner join tbl_medicamentos
			on tbl_medicamentos.id = tbl_receita_medica.id_medicamento
		inner join tbl_tipo_dosagem
			on tbl_tipo_dosagem.id = tbl_medicamentos.id_tipo_dosagem
		where tbl_usuarios.id = id_param
		order by tbl_programacao_medicamento.data_hora_inicio desc;


    elseif operacao = 'DELETE' then
        delete from tbl_programacao_medicamento
        where id = id_param;

        select row_count() as affectedRows;
        
	else
        signal sqlstate '45000'
        set message_text = 'Operação inválida na procProgramacaoMedicamento';
    end if;
END $$
DELIMITER $$

-- ======== DOENCA CRONICA USUARIO ========
DELIMITER $$
create procedure procDoencaCronicaUsuario(
    IN operacao varchar(30),
    IN id_doencas_cronicas_param int,
    IN id_usuarios_param int,
    IN id_param int
)
BEGIN
    if operacao = 'INSERT' then
        insert into tbl_doenca_cronica_usuario (
            id_doencas_cronicas,
            id_usuarios
        ) values (
            id_doencas_cronicas_param,
            id_usuarios_param
        );
        select last_insert_id() as id;

    elseif operacao = 'UPDATE' then
        update tbl_doenca_cronica_usuario
        set id_doencas_cronicas = id_doencas_cronicas_param,
            id_usuarios = id_usuarios_param
        where id = id_param;
        select row_count() as affectedRows;

    elseif operacao = 'SELECT_ALL' then
        select
            tbl_doenca_cronica_usuario.id as id_doenca_cronica_usuario,
            tbl_usuarios.id as id_usuario,
            tbl_usuarios.nome as nome_usuario,
            tbl_usuarios.email as email_usuario,
            tbl_usuarios.cpf as cpf_usuario,
            tbl_usuarios.data_nascimento as data_nascimento_usuario,
            tbl_doencas_cronicas.id as id_doencas_cronicas,
            tbl_doencas_cronicas.nome_doenca
        from tbl_doenca_cronica_usuario
        left join tbl_usuarios
            on tbl_usuarios.id = tbl_doenca_cronica_usuario.id_usuarios
        left join tbl_doencas_cronicas
            on tbl_doencas_cronicas.id = tbl_doenca_cronica_usuario.id_doencas_cronicas
        order by tbl_doenca_cronica_usuario.id desc;

    elseif operacao = 'SELECT_BY_ID' then
        select
            tbl_doenca_cronica_usuario.id as id_doenca_cronica_usuario,
            tbl_usuarios.id as id_usuario,
            tbl_usuarios.nome as nome_usuario,
            tbl_usuarios.email as email_usuario,
            tbl_usuarios.cpf as cpf_usuario,
            tbl_usuarios.data_nascimento as data_nascimento_usuario,
            tbl_doencas_cronicas.id as id_doencas_cronicas,
            tbl_doencas_cronicas.nome_doenca
        from tbl_doenca_cronica_usuario
        left join tbl_usuarios
            on tbl_usuarios.id = tbl_doenca_cronica_usuario.id_usuarios
        left join tbl_doencas_cronicas
            on tbl_doencas_cronicas.id = tbl_doenca_cronica_usuario.id_doencas_cronicas
        where tbl_doenca_cronica_usuario.id = id_param;

    elseif operacao = 'DELETE' then
        delete from tbl_doenca_cronica_usuario where id = id_param;
        select row_count() as affectedRows;

    else
        signal sqlstate '45000'
        set message_text = 'Operação inválida na procDoencaCronicaUsuario';
    end if;
END $$
DELIMITER $$

-- ======== USUARIO GOOGLE ========
DELIMITER $$
create procedure procUsuarioGoogle(
    IN operacao varchar(30),
    IN google_id_param varchar(255),
    IN id_usuario_param int,
    IN id_param int
)
BEGIN
    if operacao = 'INSERT' then
        insert into tbl_usuario_google (
            google_id,
            id_usuario
        ) values (
            google_id_param,
            id_usuario_param
        );

        select last_insert_id() as id;

    elseif operacao = 'SELECT_BY_GOOGLE_ID' then
        select
            tbl_usuario_google.id,
            tbl_usuario_google.google_id,
            tbl_usuario_google.id_usuario
        from tbl_usuario_google
        where tbl_usuario_google.google_id = google_id_param;

    elseif operacao = 'SELECT_BY_ID_USUARIO' then
        select
            tbl_usuario_google.id,
            tbl_usuario_google.google_id,
            tbl_usuario_google.id_usuario
        from tbl_usuario_google
        where tbl_usuario_google.id_usuario = id_usuario_param;

    elseif operacao = 'DELETE' then
        delete from tbl_usuario_google
        where id = id_param;

        select row_count() as affectedRows;

    end if;
END $$
DELIMITER $$