use db_medtime;

# ========== DADOS INICIAIS ==========

# Tabela Role
insert into tbl_role (role) values
('cuidador'),
('paciente');

# Tabela Tipo de dosagem
insert into tbl_tipo_dosagem (tipo_dosagem) values
('comprimido'),
('cápsula'),
('gotas'),
('solução'),
('xarope'),
('suspensão'),
('injeção'),
('pomada'),
('creme'),
('spray');

# Tabela Unidade de medida
insert into tbl_unidade_medida (unidade_medida, sigla) values
('miligrama', 'mg'),
('grama', 'g'),
('mililitro', 'ml'),
('micrograma', 'µg'),
('gota', 'gt'),
('unidade', 'un');

# Tabela Tipo Intervalo
insert into tbl_tipo_intervalo (tipo_intervalo) values
('hora'),
('dia');

# Tabela Permissões
insert into tbl_permissoes (permissao) values
('VISUALIZAR_MEDICAMENTOS'),
('CADASTRAR_MEDICAMENTOS'),
('EDITAR_MEDICAMENTOS'),
('EXCLUIR_MEDICAMENTOS'),
('CONFIRMAR_INGESTAO'),
('VISUALIZAR_HISTORICO'),
('VISUALIZAR_AGENDA'),
('VISUALIZAR_PULSEIRA'),
('VISUALIZAR_LOCALIZACAO'),
('GERENCIAR_PACIENTES'),
('EDITAR_PERFIL');

-- ROLE 1: CUIDADOR
insert into tbl_role_permissoes (id_role, id_permissoes)
select 1, id
from tbl_permissoes
where permissao in (
    'VISUALIZAR_MEDICAMENTOS',
    'CADASTRAR_MEDICAMENTOS',
    'EDITAR_MEDICAMENTOS',
    'EXCLUIR_MEDICAMENTOS',
    'VISUALIZAR_HISTORICO',
    'VISUALIZAR_AGENDA',
    'VISUALIZAR_PULSEIRA',
    'VISUALIZAR_LOCALIZACAO',
    'GERENCIAR_PACIENTES',
    'EDITAR_PERFIL'
);

-- ROLE 2: PACIENTE
insert into tbl_role_permissoes (id_role, id_permissoes)
select 2, id
from tbl_permissoes
where permissao in (
    'VISUALIZAR_MEDICAMENTOS',
    'CADASTRAR_MEDICAMENTOS',
    'EDITAR_MEDICAMENTOS',
    'EXCLUIR_MEDICAMENTOS',
    'CONFIRMAR_INGESTAO',
    'VISUALIZAR_HISTORICO',
    'VISUALIZAR_AGENDA',
    'VISUALIZAR_PULSEIRA',
    'VISUALIZAR_LOCALIZACAO',
    'EDITAR_PERFIL'
);