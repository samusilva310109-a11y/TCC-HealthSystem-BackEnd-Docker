create database db_medtime;

use db_medtime;

# ========== TABELAS ==========
# Tabela Usuários
create table tbl_usuarios (
	id 					int not null auto_increment primary key,
    nome 				varchar(45) not null,
    foto 				varchar(500) null,
    email 				varchar(255) not null unique,
    senha 				varchar(512) null,
    cpf 				varchar(20),
    telefone 			varchar(20) null,
    data_nascimento 	date not null,
    ativo				boolean not null default true,
    email_verificado 	boolean not null default false
);

# Tabela Usuario Google
create table tbl_usuario_google (
    id              int not null auto_increment primary key,
    google_id       varchar(255) not null,
    id_usuario      int not null,

    constraint UK_USUARIOGOOGLE_GOOGLEID
    unique (google_id),

    constraint UK_USUARIOGOOGLE_USUARIO
    unique (id_usuario),

    # Relação entre Usuario Google e Usuarios
    constraint FK_USUARIOGOOGLE_USUARIOS
    foreign key (id_usuario)
    references tbl_usuarios(id)
    on delete cascade
);

# Tabela Role
create table tbl_role (
	id 		int not null auto_increment primary key,
    role 	varchar(45) not null
);

# Tabela Permissôes
create table tbl_permissoes (
	id 			int not null auto_increment primary key,
    permissao 	varchar(45) not null
);

# Tabela intermediária Role Permissoes
create table tbl_role_permissoes (
	id 				int not null auto_increment primary key,
    id_role 		int not null,
    id_permissoes 	int not null,

    # Relação entre a intermediaria e a tabela role
    constraint	FK_ROLEPERMISSOES_ROLE
    foreign key (id_role)
    references 	tbl_role(id)
    on delete cascade,

    # Relação entre a intermediaria e a tabela permissoes
    constraint 	FK_ROLEPERMISSOES_PERMISSOES
    foreign key (id_permissoes)
    references 	tbl_permissoes(id)
    on delete cascade
);

# Tabela intermediária Usuarios Role
create table tbl_usuarios_role (
	id 					int not null auto_increment primary key,
    ativo 				tinyint not null,
    data_ativacao 		datetime not null,
    data_desativacao 	datetime,
    id_usuarios 		int not null,
    id_role 			int not null,

    # Relação entre UsuariosRole e Usuarios
    constraint 	FK_USUARIOSROLE_USUARIOS
    foreign key (id_usuarios)
    references 	tbl_usuarios(id)
    on delete cascade,

    # Relação entre UsuariosRole e Role
    constraint 	FK_USUARIOSROLE_ROLE
    foreign key (id_role)
    references 	tbl_role(id)
);

# Tabela Contato de emergencia
create table tbl_contato_de_emergencia (
	id 			int not null auto_increment primary key,
    nome 		varchar(45) not null,
    telefone 	varchar(15) not null
);

# Tabela intermediária entre Contado de emergencia e Usuarios
create table tbl_contato_emergencia_usuarios (
	id 							int not null auto_increment primary key,
    id_contato_de_emergencia 	int not null,
    id_usuarios 				int not null,

    # Relação entre a intermediaria e a tabela contato de emergencia
    constraint 	FK_CONTATOEMERGENCIAUSUARIOS_CONTATOEMERGENCIA
    foreign key (id_contato_de_emergencia)
    references 	tbl_contato_de_emergencia(id)
    on delete cascade,

    # Relação entre a intermediaria e a tabela usuarios
    constraint 	FK_CONTATOEMERGENCIAUSUARIOS_USUARIOS
    foreign key (id_usuarios)
    references 	tbl_usuarios(id)
    on delete cascade
);

# Tabela Doenças cronicas
create table tbl_doencas_cronicas (
	id 			int not null auto_increment primary key,
    nome_doenca varchar(45) not null
);

# Tabela intermediária entre Doenças crônicas e Usuarios
create table tbl_doenca_cronica_usuario (
	id 					int not null auto_increment primary key,
    id_doencas_cronicas int not null,
    id_usuarios 		int not null,

    # Relação entre a intermedária e Doenças crônicas
    constraint 	FK_DOENCACRONICAUSUARIO_DOENCASCRONICAS
    foreign key (id_doencas_cronicas)
    references 	tbl_doencas_cronicas(id)
    on delete cascade,

	# Relação entre a intermedária e Usuarios
    constraint 	FK_DOENCACRONICAUSUARIO_USUARIOS
    foreign key (id_usuarios)
    references 	tbl_usuarios(id)
    on delete cascade
);

# Tabela vinculo paciente
create table tbl_vinculo_paciente (
    id              int not null auto_increment primary key,
    data_vinculo    datetime not null,
    id_paciente     int not null,
    id_cuidador     int not null,

    constraint UK_VINCULO_PACIENTE
    unique (id_paciente),

    constraint FK_VINCULO_PACIENTE
    foreign key (id_paciente)
    references tbl_usuarios(id)
    on delete cascade,

    constraint FK_VINCULO_CUIDADOR
    foreign key (id_cuidador)
    references tbl_usuarios(id)
    on delete cascade
);

create table tbl_codigos_verificacao (
    id 				int not null auto_increment primary key,
    codigo_hash 	varchar(255) not null,
    tipo 			varchar(30) not null,
    id_usuario 		int null,
    email 			varchar(255) null,
    data_expiracao 	datetime not null,
    utilizado 		boolean not null default false,
    tentativas 		int not null default 0,
    
    constraint UK_CODIGO_HASH_TIPO
	unique (codigo_hash, tipo),

    constraint FK_USUARIO_CODIGO_VERIFICACAO
    foreign key (id_usuario)
    references tbl_usuarios(id)
);


# Tabela Tipo de dosagem
create table tbl_tipo_dosagem (
	id 				int not null auto_increment primary key,
    tipo_dosagem 	varchar(12) not null
);

# Tabela Unidade de medida
create table tbl_unidade_medida (
	id 				int not null auto_increment primary key,
    unidade_medida 	varchar(30) not null,
    sigla varchar(6) not null
);

# Tabela de medicamentos
create table tbl_medicamentos (
	id 								int not null auto_increment primary key,
    nome 							varchar(45) not null,
    imagem 							varchar(255) not null,
    concentracao 					decimal(5,2) not null,
    id_unidade_medida_embalagem 	int not null,
    id_tipo_dosagem 				int not null,
    id_usuario                      int,

    # Relação entre Medicamento e unidade de medida
    constraint 	FK_MEDICAMENTO_UNIDADEMEDIDAEMBALAGEM
    foreign key (id_unidade_medida_embalagem)
    references 	tbl_unidade_medida(id),

    # Relação entre Medicamento e tipo de dosagem
    constraint 	FK_MEDICAMENTO_TIPODOSAGEM
    foreign key (id_tipo_dosagem)
    references 	tbl_tipo_dosagem(id),
    
    constraint FK_MEDICAMENTO_USUARIO
    foreign key (id_usuario)
    references tbl_usuarios(id)
);

# Tabela Estoque
create table tbl_estoque (
	id 						int not null auto_increment primary key,
	quantidade_em_estoque 	decimal(7,2) not null,
    id_usuarios 			int not null,
    id_medicamentos			int not null,

    # Relação entre Estoque e Usuarios
    constraint 	FK_ESTOQUE_USUARIOS
    foreign key (id_usuarios)
    references 	tbl_usuarios(id)
    on delete cascade,

    # Relação entre Estoque e Medicamento
    constraint 	FK_ESTOQUE_MEDICAMENTOS
    foreign key (id_medicamentos)
    references 	tbl_medicamentos(id)
);

# Tabela Tipo Intervalo
create table tbl_tipo_intervalo (
    id 				int not null auto_increment primary key,
    tipo_intervalo 	varchar(5) not null
);

# Tabela Receita Médica
create table tbl_receita_medica (
    id                  int not null auto_increment primary key,
    id_usuario          int not null,
    id_medicamento      int not null,
    dosagem             decimal(5,2) not null,
    id_unidade_medida   int not null,
    id_estoque 			int not null,
    descricao           text,

    constraint FK_RECEITAMEDICA_USUARIO
    foreign key (id_usuario)
    references tbl_usuarios(id)
    on delete cascade,

    constraint FK_RECEITAMEDICA_MEDICAMENTO
    foreign key (id_medicamento)
    references tbl_medicamentos(id),

    constraint FK_RECEITAMEDICA_UNIDADEMEDIDA
    foreign key (id_unidade_medida)
    references tbl_unidade_medida(id),
    
    constraint FK_RECEITAMEDICA_ESTOQUE
    foreign key (id_estoque)
    references tbl_estoque(id)
);

# Tabela Programação Medicamento
create table tbl_programacao_medicamento (
    id                  int not null auto_increment primary key,
    frequencia 			int not null,
    data_hora_inicio    datetime not null,
    data_hora_fim       datetime,
    id_tipo_intervalo   int not null,
    id_receita_medica   int not null,
    
    constraint CK_PROGRAMACAO_FREQUENCIA
	check (frequencia > 0),

	constraint CK_PROGRAMACAO_PERIODO
	check (data_hora_fim is null or data_hora_fim > data_hora_inicio),

    # Relação entre Programação Medicamento e Tipo Intervalo
    constraint FK_PROGRAMACAOMEDICAMENTO_TIPOINTERVALO
    foreign key (id_tipo_intervalo)
    references tbl_tipo_intervalo(id),

    # Relação entre Programação Medicamento e Receita Médica
    constraint FK_PROGRAMACAOMEDICAMENTO_RECEITAMEDICA
    foreign key (id_receita_medica)
    references tbl_receita_medica(id)
    on delete cascade
);

# Tabela de Histórico de Medicamentos
create table tbl_historico_medicamento (
    id                      int not null auto_increment primary key,
    hora_ingestao           datetime not null,
    id_paciente             int not null,
    id_receita_medica       int,
    dosagem_ingerida        decimal(5,2) not null,
    horario_programado      datetime not null,
    nome_medicamento        varchar(45) not null,
    concentracao            decimal(5,2) not null,
    unidade_concentracao    varchar(6) not null,
    tipo_dosagem            varchar(12) not null,

    constraint UK_HISTORICO_RECEITA
    unique (id_receita_medica, horario_programado),

    constraint FK_HISTORICO_PACIENTE
    foreign key (id_paciente)
    references tbl_usuarios(id),

    constraint FK_HISTORICO_RECEITAMEDICA
    foreign key (id_receita_medica)
    references tbl_receita_medica(id)
    on delete set null
);