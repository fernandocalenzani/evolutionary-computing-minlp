
%% PROJETO : INICIAÇÃO CIENTÍFICA TECNILÓGICA
% Nome Orientador :   Dr. Clainer Bravim Donadel
% Grupo de Pesquida:  Gestão de Energia, Máquinas e Manutenção
% Nome Aluno :          Fernando Calenzani Muller
% e-mail :                   fernandocalenzani@gmail.com
%                               cdonadel@ifes.edu.br 

%%  IEEE123B -  OpenDSS INTERFACE COM MATLAB
clc;
clear;
close all;
tic % calcula o tempo de simulação

%% DECLARAÇÃO DE VARIÁVEIS GLOBAIS
p = 1;
vet_gen(1,1:16)=1;
indice = 1;
i=1;

%% CRIAÇÃO DO OBJETO OPENDSS

% Criando o objeto OpenDSS
DSSObj = actxserver('OpenDSSEngine.DSS');
 % Verificando se o OpenDSS foi criado com sucesso
 if ~DSSObj.Start(0),
     disp('Incapaz de criar OpenDSS');
 else
     disp('Interface COM iniciada com sucesso!');
 end
 
clc;

% Criando atalhos para as 3 principais interfaces
DSSText = DSSObj.Text;
DSSCircuit = DSSObj.ActiveCircuit;
DSSSolution = DSSCircuit.Solution;
DSSBus = DSSCircuit.ActiveBus;
DSSLines = DSSCircuit.Lines;
DSSElement = DSSCircuit.ActiveCktElement;

% Carregando o arquivo OpenDSS
DSSText.Command ='Compile (C:\Users\ferna\Dropbox\Engenharia Elétrica\ICT Sistemas Elétricos de Distribuição\Projeto\IEEE123Bus\Master.dss)';

%% PARAMETROS DA REDE TESTE
%______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
% TIPOS DE CABOS DA REDE TESTE
% 1) Rede aérea :
%  - cabo nú : aluminio e isolacao com verniz
%  - cabo pré-reunido : 
%  - cabo protegido : cabo de alumínio dotado de cobertura protetora de composto extrudado de polímero termofixo ou termoplástico
%  - cabo protegido compacto

% Nus: são fios e cabos sem isolação nenhuma, normalmente aplicados em redes elétricas de distribuição ou de transmissão
% AC – aluminum cable
% AAAC – all aluminum alloy conductor,
% ACSR – aluminum cable steel reinforced 
% ACAR – Aluminum conductor alloy reinforced);
% Isolados: são aqueles cujo condutor é revestido por um material para isolá-lo do meio que o circunda (termoplásticos: PVC – cloreto de polivinila e PE – polietileno; termofixos: XLPE – polietileno reticulado e EPR – borracha etileno propileno).
% CORRENTE ADMISSÍVEL NOS CABOS 
% NOMENCLATURA: cabo_[A- Aéreo ; S - Subterraneo]_[nome do cabo]_[Tipo de Cabo]

% % CATÁLOGO : https://www.induscabos.com.br/portfolio-item/fios-e-cabos-de-aluminio-nu-caa-acsr/
% cabo_A_336_4_ACSR = 500; 
% cabo_A_1_0_ACSR = 230;
% cabo_S_1_0_AA = 214;
% 
% % CATÁLOGO : https://www.alubar.net.br/
% cabo_A_336_4_ACSR = 580; 
% cabo_A_1_0_ACSR = 284;
% cabo_S_1_0_AA = 278;

% CATÁLOGO : Dados Professor
cabo_A_336_4_ACSR = 453; 
cabo_A_1_0_ACSR = 214;
cabo_S_1_0_AA = 278;

%______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
% PARAMETROS DAS CARGAS DO OPENDSS
nome = {'S1a', 'S2b', 'S4c', 'S5c', 'S6c', 'S7a', 'S9a', 'S10a', 'S11a', 'S12b', 'S16c', 'S17c', 'S19a', 'S20a', 'S22b', 'S24c', 'S28a', 'S29a', 'S30c','S31c' ,'S32c' ,'S33a' ,'S34c' ,'S35a' ,'S37a' ,'S38b' ,'S39b' ,'S41c' ,'S42a' ,'S43b' ,'S45a' ,'S46a' ,'S47'  ,'S48'  ,'S49a' ,'S49b' ,'S49c' ,'S50c' ,'S51a' ,'S52a' ,'S53a' ,'S55a' ,'S56b' ,'S58b' ,'S59b' ,'S60a' ,'S62c' ,'S63a' ,'S64b' ,'S65a' ,'S65b' ,'S65c' ,'S66c' ,'S68a' ,'S69a'  ,'S70a'  ,'S71a'  ,'S73c'  ,'S74c'  ,'S75c'  ,'S76a'  ,'S76b'  ,'S76c'  ,'S77b'  ,'S79a' ,'S80b' ,'S82a' ,'S83c' ,'S84c' ,'S85c' ,'S86b' ,'S87b' ,'S88a' ,'S90b' ,'S92c' ,'S94a' ,'S95b' ,'S96b' ,'S98a' ,'S99b' ,'S100c','S102c','S103c','S104c','S106b','S107b','S109a','S111a' ,'S112a','S113a','S114a'};
phases =  [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 3 3 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
bus = {'1.1' ,   '2.2'  ,  '4.3'  ,  '5.3'  ,  '6.3'  ,  '7.1'  ,  '9.1'  ,  '10.1'  , '11.1'  , '12.2' ,  '16.3' ,  '17.3' ,  '19.1'  , '20.1' ,  '22.2'  , '24.3'  , '28.1'  , '29.1' ,  '30.3',   '31.3' ,  '32.3'  , '33.1' ,  '34.3'  , '35.1.2' ,'37.1' ,  '38.2' ,  '39.2' ,  '41.3'  , '42.1' ,  '43.2'  , '45.1'  , '46.1'  , '47'  ,   '48'  ,   '49.1'  , '49.2'  , '49.3'  , '50.3'  , '51.1'  , '52.1'  , '53.1'  , '55.1' ,  '56.2'  , '58.2'  , '59.2'  , '60.1'  , '62.3'  , '63.1'  , '64.2',   '65.1.2', '65.2.3', '65.3.1', '66.3' ,  '68.1' ,  '69.1' ,  '70.1'  , '71.1'  , '73.3'  , '74.3'  , '75.3' ,  '76.1.2', '76.2.3', '76.3.1' ,'77.2' ,  '79.1' ,  '80.2' ,  '82.1',   '83.3'  , '84.3'  , '85.3' ,  '86.2' ,  '87.2'  , '88.1' ,  '90.2' ,  '92.3' ,  '94.1' ,  '95.2' ,  '96.2'  , '98.1' ,  '99.2'  , '100.3' , '102.3' , '103.3' , '104.3' , '106.2' , '107.2' , '109.1' , '111.1' , '112.1' , '113.1' , '114.1'};
model = [1 1 1 5 2 1 1 5 2 1 1 1 1 5 2 1 5 2 1 1 1 5 2 1 2 5 1 1 1 2 5 1 5 2 1 1 1 1 1 1 1 2 1 5 1 1 2 1 5 2 2 2 1 1 1 1 1 1 2 1 5 5 5 1 2 1 1 1 1 1 1 1 1 5 1 1 1 1 1 1 2 1 1 1 1 1 1 1 5 2 1];
Conn = {'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Delta' ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Delta' ,'Delta' ,'Delta' ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Delta' ,'Delta' ,'Delta' ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'   ,'Wye'}   ;
kV = [2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 4.160 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 4.160 4.160 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 4.160 4.160 4.160 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 4.160 4.160 4.160 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40 2.40];
% POTENCIA ATIVA REDE ORIGINAL
kS(1,:) =[40 20 40 20 40 20 40 20 40 20 40 20 40 40 40 40 40 40 40 20 20 40 40 40 40 20 20 20 20 40 20 20 105 210 35 70 35 40 20 40 40 20 20 20 20 20 40 40 75 35 35 70 75 20 40 20 40 40 40 40 105 70 70 40 40 40 40 20 20 40 20 40 40 40 40 40 20 20 40 40 40 20 40 40 40 40 40 20 20 40 20];
% POTENCIA REATIVA REDE ORIGINAL
kS(2,:) =[20 10 20 10 20 10 20 10 20 10 20 10 20 20 20 20 20 20 20 10 10 20 20 20 20 10 10 10 10 20 10 10 75 150 25 50 20 20 10 20 20 10 10 10 10 10 20 20 35 25 25 50 35 10 20 10 20 20 20 20 80 50 50 20 20 20 20 10 10 20 10 20 20 20 20 20 10 10 20 20 20 10 20 20 20 20 20 10 10 20 10];
% POTENCIA APARENTE E FP REDE ORIGINAL
for i = 1:91
kS(3,i) = sqrt(kS(1,i).^2+kS(2,i).^2);
kS(4,i) = kS(1,i)/kS(3,i);
end

%______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
% NOME DE TODOS ELEMENTOS DA REDE IEEE123B
% VSource       : 1
% Line             : 4-121
% Switch          : 122-133
% Transformer  : 2,134,139-144,243
% reguladores  : 3,145-150
% capacitor      : 135-138
% Load            : 151-241
% energymeter : 242
% pvsystem1     :244
ElementsName = DSSCircuit.AllElementNames; % Vetor tipo CELL com nome de todos os elementos
NameVSource = ElementsName(1);
NameLine = ElementsName(4:121);
NameTransformer(1,1) = ElementsName(2);
NameTransformer(2,1) = ElementsName(134);
NameTransformer(3:8,1) = ElementsName(139:144);
NameReg(1,1) = ElementsName(3);
NameReg(2:7,1) = ElementsName(145:150);
NameSwitch = ElementsName(122:133);
NameCapacitor = ElementsName(135:138);
NameLoads = ElementsName(151:241);
NameEnergyMeter = ElementsName(242);
%______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________

%% PARAMETROS DA SIMULAÇÃO

%_____________________________________________________%
% PREENCHA OS DADOS DA SIMULAÇÃO         %
%_____________________________________________________%
loop_test = 's';                                                 %     % Caso queira fazer a simulação Teste, coloque 's'.
Add_CG='s';                                                    %     % Caso queira adicionar curvas de carga a simulação, coloque 's'
Add_DG='s';                                                    %     % Caso queira adicionar as gerações distribuídas a simulação, coloque 's'
n_simulacao = 'Simulacao_1_c3_pcc3_g3_pcg3';   %     % Nome do Arquivo
Npontoscurvacarga = 3;                                   %     % Número de pontos da curva de carga                                                                        
Npontoscurvageracao = 3;                                %     % Número de pontos da curva de geração 
tipo_curva_carga = 'Gaussiana Truncada';           %     % Modelo da curva de carga
tipo_curva_geracao = 'Beta';                             %     % Modelo da curva de geracao
tipo_geracao = 'fotovoltaico';                            %     % Natureza da Geração  
fator_min_carga=0.1;                                        %     % significa que o menor valor de carga será fator_min_carga*[Carga Média]
fator_max_carga=2;                                         %     % significa que o maior valor de carga será fator_max_carga*[Carga Média]
fatorMult_potencia =1;                                     %     %  Fator multiplicativo da potencia gereção distribuida.
Barra_C_1=91;                                                 %      % PERTENCE A BARRA DO LOOPTEST
Barra_C_2=90;                                                %      % PERTENCE A BARRA DO LOOPTEST
Barra_C_3=89;                                                %      % PERTENCE A BARRA DO LOOPTEST
Barra_C_4=33;                                                %      
Barra_C_5=34;                                                %
Barra_G_1=91;                                                 %       % PERTENCE A BARRA DO LOOPTEST
Barra_G_2=90;                                                %       % PERTENCE A BARRA DO LOOPTEST
Barra_G_3=89;                                                %       % PERTENCE A BARRA DO LOOPTEST
Barra_G_4=35;                                                %
Barra_G_5=36;                                                %  
%_____________________________________________________%
% *Numero de Barras de carga e geração são fixos, definidos como Nbarrasgeracao = Nbarrascargas = 5 para simulação completa e Nbarrasgeracao = Nbarrascargas = 3 para o LoopTest
% ** Barra_C_x é a posicao do vetor bus referente a barra a qual se deseja adicionar a curva de carga
% *** Barra_G_x é a posicao do vetor bus referente a barra a qual se deseja adicionar a curva de geração
%__________________________________________________________________________________________________________________________________________________________________________________________________________________________________

% OUTROS DADOS
if loop_test=='s'
Nbarrascarga = 3; % Numero de barras  de carga simuladas
Nbarrasgeracao = 3; % Numero de barras  de carga simuladas
else
Nbarrascarga = 5; % Numero de barras  de carga simuladas
Nbarrasgeracao = 5; % Numero de barras  de carga simuladas
end

Total_Simulacoes = (Npontoscurvacarga.^Nbarrascarga).*(Npontoscurvageracao.^Nbarrasgeracao);      % Numero total de simulações

disp('________________________________________________________________________________________________________________')
disp('INICIANDO SIMULAÇÃO');
disp('DADOS:');
fprintf('    Simulação        NBC NBG NpcC NpcG   ModeloCarga      ModGer    NaturezaGer    NumSim');
{n_simulacao Nbarrascarga Nbarrasgeracao Npontoscurvacarga Npontoscurvageracao tipo_curva_carga tipo_curva_geracao tipo_geracao Total_Simulacoes}

%% ADICIONANDO MODELOS DE CURVA DE CARGA

if Add_CG == 's'

% DETALHES DAS CURVAS DE GERACAO E CARGA
% PARAMETROS DA CURVA DE CARGA

Carga_VA_med = kS(3,1); % valor médio que a curva de carga assume, foi colocado inicialmente o valor da potencia aparente da Rede IEEE123 S= 40+i20
Carga_VA_max = fator_max_carga.*Carga_VA_med;
Carga_VA_min  = fator_min_carga.*Carga_VA_med;
Curva_Carga_Gaussiana(1,:) = linspace(Carga_VA_min,Carga_VA_max,Npontoscurvacarga)/Carga_VA_max; % calculando os pontos de potencia consumida (+2 porque os pontos iniciais e finais possuem valores de prob conhecidos e nao serao usados)
Curva_Carga_Gaussiana(2,:) = Carga_VA_max.*Curva_Carga_Gaussiana(1,:);
Carga_VA_desvpad = sqrt(var(Curva_Carga_Gaussiana(2,:))); % desvio padrao
pd = makedist ( 'Normal' , 'mu' , Carga_VA_med, 'sigma' , Carga_VA_desvpad); % criando o objeto Curva Normal Gaussiana
t = truncate(pd,Carga_VA_min,Carga_VA_max); % Truncando a Curva
Curva_Carga_Gaussiana(3,:) = pdf(t,Curva_Carga_Gaussiana(2,:));
end

%% ADICIONANDO GERAÇÃO DISTRIBUIDA

if Add_DG=='s'
    
%% MODELOS DA CURVA DE GERAÇÃO

% PARAMETROS DAS GERAÇÕES DISTRIBUIDA

%--------------------FOTOVOLTAICA (UFV)--------------------

if fatorMult_potencia> 0
% 1 - Carregamento dos dados de irradiação/potencia
arquivo ='C:\Users\ferna\Dropbox\Engenharia Elétrica\ICT Sistemas Elétricos de Distribuição\Projeto\Geração Distribuída\Dados de irradiação - Petrolina FV1 EnerqUSP PV\Weather data Sao Paulo_USP-ENERQ_5minutes_01-06-2014_10-06-2014.xlsx';
Pout_GD = xlsread(arquivo,'Pout_DG_15h');

% 2 - encontrando os parametros alfa e beta
Pout_GD =fatorMult_potencia.*Pout_GD; % Vetor que possui a potencia gerada pela unidade de geração fotovoltaica
Pout_GD = Pout_GD';
Pout_GD_max =max(Pout_GD); % maximo do vetor R
Pout_GD_min =min(Pout_GD);  % mínimo do vetor R 
Pout_GD_norm = Pout_GD/Pout_GD_max;  % normalizacao do vetor R para utilizar na fdp Beta
mu = mean(Pout_GD_norm); % média do vetor R normalizado
sigma=std(Pout_GD_norm); % Desvio padrao do vetor R normalizado
beta = (1 - mu).*((mu.*(1-mu))/(sigma.^2) -1);
alfa = mu*beta/(1-mu);

tam=size(Pout_GD_norm);
incremento = fix(tam(1,2)/Npontoscurvageracao);
pmax = find(Pout_GD==Pout_GD_max);
pmin = find(Pout_GD==Pout_GD_min);
Curva_Geracao_Beta(1,1)=0.9999.*Pout_GD_norm(1,pmax);
Curva_Geracao_Beta(1,2)=Pout_GD_norm(1,pmin);
i=3;
while(i<= Npontoscurvageracao)
  Curva_Geracao_Beta(1,i) =Pout_GD_norm(1,i.*incremento);
  i=i+1;
end

% 3 - FDP Beta
Curva_Geracao_Beta(2,:) = Pout_GD_max.*Curva_Geracao_Beta(1,:);
Curva_Geracao_Beta(3,:)= betapdf(Curva_Geracao_Beta(1,:),alfa,beta);

else
 Curva_Geracao_Beta(1,:)=zeros(1,Npontoscurvageracao);
 Curva_Geracao_Beta(2,:)=zeros(1,Npontoscurvageracao);
 Curva_Geracao_Beta(3,:)=ones(1,Npontoscurvageracao);
 end
    
%% PARAMETROS DAS DG's
% este trecho faz a adição das gerações ditribuidas na rede IEEE123B


%_________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
%                FOTOVOLTAICA
%_________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________

% 1 )
% EFICIENCIA SOB CONDIÇÕES PADRÃO TESTE : Temperatura = 25° , Irradiancia = 1000 W/m2 , Coeficiente de Massa de Ar = 1.5 
% EX: para um módulo de  1m^2, com eficiencia de 15%, potencia nominal de
% pico será 150 Wp (STC - Standart Test Conditions)

% 2 )
% CONSIDERAÇÕES FEITAS PARA PERDAS DE ENERGIA:
% - PERFORMACE RATE - PR - perdas de eficiência,incompatibilidade de módulos, variações na irradiação, sujeira, perdas por resistência e pelo inversor

% 3)
% TIPOS DE PERDAS :
% PERDAS POR TEMPERATURA
% PERDAS DO INVERSOR
% SUJIDADE
% SOMBREAMENTO
% UMIDADE
% DEGRADAÇÃO
% VELOCIDADE DO VENTO
% COEFICIENTE DE MONTAGEM

% 4) 
% PARÂMETROS DA DG:
% i)   Curva Eficiencia x Temperatura
% ii)  Curva Eficiencia do Inversor
% iii) Curva de Irradiação 
% iv) Curva de temperatura 
% v) Outros parametros

% i) EFICIENCIA X TEMPERATURA----------------------------------------------
% ii) EFICIENCIA DO INVERSOR----------------------------------------------
% iii) EFICIENCIA DO INVERSOR----------------------------------------------
% iv) CURVA DE TEMPERATURA----------------------------------------------
% v) OUTROS PARAMETROS DO PVSYSTEM----------------------------------------------

% Curva_Geracao_Beta(1,:)  Potencia gerada pela UFV normalizada
% Curva_Geracao_Beta(2,:) Potencia gerada não normalizada
% Curva_Geracao_Beta(3,:)  Probabilidade de ocorrencia

% PARAMETROS UFV 1:
nomeUFV1 = 'UFV_1';
BusUFV1 = 'BusUFV1';
kV_UFV1 = 0.22;
Pufv1=Curva_Geracao_Beta(2,1);
PF_UFV1=1;
VpuUFV1='1.00';
ModeloUFV1='3';
MaxkvarUFV1=50;
MinkvarUFV1=0;
% PARAMETROS UFV 2:
nomeUFV2 = 'UFV_2';
BusUFV2 = 'BusUFV2';
kV_UFV2 = 0.22;
Pufv2=Curva_Geracao_Beta(2,1);
PF_UFV2=1;
VpuUFV2='1.00';
ModeloUFV2='3';
MaxkvarUFV2=50;
MinkvarUFV2=0;
% PARAMETROS UFV 3:
nomeUFV3 = 'UFV_3';
BusUFV3 = 'BusUFV3';
kV_UFV3 = 0.22;
Pufv3=Curva_Geracao_Beta(2,1);
PF_UFV3=1;
VpuUFV3='1.00';
ModeloUFV3='3';
MaxkvarUFV3=50;
MinkvarUFV3=0;
% PARAMETROS UFV 4:
nomeUFV4 = 'UFV_4';
BusUFV4 = 'BusUFV4';
kV_UFV4 = 0.22;
Pufv4=Curva_Geracao_Beta(2,1);
PF_UFV4=1;
VpuUFV4='1.00';
ModeloUFV4='3';
MaxkvarUFV4=50;
MinkvarUFV4=0;
% PARAMETROS UFV 5:
nomeUFV5 = 'UFV_5';
BusUFV5 = 'BusUFV5';
kV_UFV5 = 0.22;
Pufv5=Curva_Geracao_Beta(2,1);
PF_UFV5=1;
VpuUFV5='1.00';
ModeloUFV5='3';
MaxkvarUFV5=50;
MinkvarUFV5=0;

%% ADICIONANDO AS GERAÇÕES DISTRIBUIDAS
%.................................................................................................UFV 1.............................................................................................................
% PVSystem.UFV1  - colocando a DG no opendss 
% DEFININDO UM TRANSFORMADOR ELEVADOR DE 0.22 kV para 2.4 kV F-N
DSSText.Command = char(strcat('New Transformer.Trafo',nomeUFV1 ,' phases=',num2str(phases(Barra_G_1)),' Windings=2  Xhl=2.72 Wdg=1',' bus=', (bus(Barra_G_1)),' Conn=',Conn(Barra_G_1),'   kV=',num2str(kV(Barra_G_1)) ,' kVA=150  %R=0.635 Wdg=2    Bus=',  BusUFV1  ,' Conn=' ,num2str(Barra_G_1) , '  kV=' ,  num2str(kV_UFV1)  ,   ' kVA=150       %R=0.635' ));
% INSERINDO PVSYSTEM NO OPENDSS
DSSText.Command = char(strcat('New Generator.',nomeUFV1, ' phases=',num2str (phases(Barra_G_1)),' bus1=',BusUFV1,' kV=',num2str (kV_UFV1),' kW=', num2str (Pufv1) ,' PF=', num2str (PF_UFV1),' Vpu= ',num2str (VpuUFV1) ,' Model=',char(ModeloUFV1),' Maxkvar=',num2str(MaxkvarUFV1),' Minkvar=',num2str(MinkvarUFV1) ,' Conn=',Conn(Barra_G_1)));

%.................................................................................................UFV 2.............................................................................................................
% PVSystem.UFV2  - colocando a DG no opendss 
% DEFININDO UM TRANSFORMADOR ELEVADOR DE 0.22 kV para 2.4 kV F-N
DSSText.Command = char(strcat('New Transformer.Trafo',nomeUFV2 ,' phases=',num2str(phases(Barra_G_2)),' Windings=2  Xhl=2.72 Wdg=1',' bus=', (bus(Barra_G_2)),' Conn=',Conn(Barra_G_2),'   kV=',num2str(kV(Barra_G_2)) ,' kVA=150  %R=0.635 Wdg=2    Bus=',  BusUFV2  ,' Conn=' ,num2str(Barra_G_2) , '  kV=' ,  num2str(kV_UFV2)  ,   ' kVA=150       %R=0.635' ));
% INSERINDO PVSYSTEM NO OPENDSS
DSSText.Command = char(strcat('New Generator.',nomeUFV2, ' phases=',num2str (phases(Barra_G_2)),' bus1=',BusUFV2,' kV=',num2str (kV_UFV2),' kW=', num2str (Pufv2) ,' PF=', num2str (PF_UFV2),' Vpu= ',num2str (VpuUFV2) ,' Model=',char(ModeloUFV2),' Maxkvar=',num2str(MaxkvarUFV2),' Minkvar=',num2str(MinkvarUFV2) ,' Conn=',Conn(Barra_G_2)));

%.................................................................................................UFV 3.............................................................................................................
% PVSystem.UFV3  - colocando a DG no opendss 
% DEFININDO UM TRANSFORMADOR ELEVADOR DE 0.22 kV para 2.4 kV F-N
DSSText.Command = char(strcat('New Transformer.Trafo',nomeUFV3 ,' phases=',num2str(phases(Barra_G_3)),' Windings=2  Xhl=2.72 Wdg=1',' bus=', (bus(Barra_G_3)),' Conn=',Conn(Barra_G_3),'   kV=',num2str(kV(Barra_G_3)) ,' kVA=150  %R=0.635 Wdg=2    Bus=',  BusUFV3  ,' Conn=' ,num2str(Barra_G_3) , '  kV=' ,  num2str(kV_UFV3)  ,   ' kVA=150       %R=0.635' ));
% INSERINDO PVSYSTEM NO OPENDSS
DSSText.Command = char(strcat('New Generator.',nomeUFV3, ' phases=',num2str (phases(Barra_G_3)),' bus1=',BusUFV3,' kV=',num2str (kV_UFV3),' kW=', num2str (Pufv3) ,' PF=', num2str (PF_UFV3),' Vpu= ',num2str (VpuUFV3) ,' Model=',char(ModeloUFV3),' Maxkvar=',num2str(MaxkvarUFV3),' Minkvar=',num2str(MinkvarUFV3) ,' Conn=',Conn(Barra_G_3)));

%.................................................................................................UFV 4.............................................................................................................
% PVSystem.UFV4  - colocando a DG no opendss 
% DEFININDO UM TRANSFORMADOR ELEVADOR DE 0.22 kV para 2.4 kV F-N
DSSText.Command = char(strcat('New Transformer.Trafo',nomeUFV4 ,' phases=',num2str(phases(Barra_G_4)),' Windings=2  Xhl=2.72 Wdg=1',' bus=', (bus(Barra_G_4)),' Conn=',Conn(Barra_G_4),'   kV=',num2str(kV(Barra_G_4)) ,' kVA=150  %R=0.635 Wdg=2    Bus=',  BusUFV4  ,' Conn=' ,num2str(Barra_G_4) , '  kV=' ,  num2str(kV_UFV4)  ,   ' kVA=150       %R=0.635' ));
% INSERINDO PVSYSTEM NO OPENDSS
DSSText.Command = char(strcat('New Generator.',nomeUFV4, ' phases=',num2str (phases(Barra_G_4)),' bus1=',BusUFV4,' kV=',num2str (kV_UFV4),' kW=', num2str (Pufv4) ,' PF=', num2str (PF_UFV4),' Vpu= ',num2str (VpuUFV4) ,' Model=',char(ModeloUFV4),' Maxkvar=',num2str(MaxkvarUFV4),' Minkvar=',num2str(MinkvarUFV4) ,' Conn=',Conn(Barra_G_4)));

%.................................................................................................UFV 5.............................................................................................................
% PVSystem.UFV5  - colocando a DG no opendss 
% DEFININDO UM TRANSFORMADOR ELEVADOR DE 0.22 kV para 2.4 kV F-N
DSSText.Command = char(strcat('New Transformer.Trafo',nomeUFV5 ,' phases=',num2str(phases(Barra_G_5)),' Windings=2  Xhl=2.72 Wdg=1',' bus=', (bus(Barra_G_5)),' Conn=',Conn(Barra_G_5),'   kV=',num2str(kV(Barra_G_5)) ,' kVA=150  %R=0.635 Wdg=2    Bus=',  BusUFV5  ,' Conn=' ,num2str(Barra_G_5) , '  kV=' ,  num2str(kV_UFV5)  ,   ' kVA=150       %R=0.635' ));
% INSERINDO PVSYSTEM NO OPENDSS
DSSText.Command = char(strcat('New Generator.',nomeUFV5, ' phases=',num2str (phases(Barra_G_5)),' bus1=',BusUFV5,' kV=',num2str (kV_UFV5),' kW=', num2str (Pufv5) ,' PF=', num2str (PF_UFV5),' Vpu= ',num2str (VpuUFV5) ,' Model=',char(ModeloUFV5),' Maxkvar=',num2str(MaxkvarUFV5),' Minkvar=',num2str(MinkvarUFV5) ,' Conn=',Conn(Barra_G_5)));

%_________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
DSSText.Command =char('Solve');
%_________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________

% ADICIONA O NOME DAS UFV E TRANSFORMADORES ACRESCENTADOS A REDE IEEE123B NO VETOR ElementsName
ElementsName = DSSCircuit.AllElementNames;
NameTransformer(9,1) = ElementsName(243);
NameUFV(1,1) = ElementsName(244);
NameTransformer(10,1) = ElementsName(243);
NameUFV(2,1) = ElementsName(244);
NameTransformer(11,1) = ElementsName(245);
NameUFV(3,1) = ElementsName(246);
NameTransformer(12,1) = ElementsName(247);
NameUFV(4,1) = ElementsName(248);
NameTransformer(13,1) = ElementsName(249);
NameUFV(5,1) = ElementsName(250);

end

%% LOOPS
if loop_test =='s'        
%% INICIO DO LOOP TEST


disp('Iniciando o Loop Test, tempo aproximado de espera em s : '); t = Total_Simulacoes*26.8/(729) 
disp('... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ...  ... ... ... ... ... ... ... ... ... ... ...  ... ... ... ...');
%________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
% LOOP - CADA PONTO RESPECTIVO A CURVA DE DENSIDADE DE PROBABILIDADE
for p1=1:Npontoscurvacarga % Carga 1
for p2=1:Npontoscurvacarga % Carga 2
for p3=1:Npontoscurvacarga % Carga 3
for p6=1:Npontoscurvageracao % Geração 6
for p7=1:Npontoscurvageracao % Geração 7
for p8=1:Npontoscurvageracao % Geração 8

% ACESSA O OPENDSS E AJUSTA O VALOR DA POTENCIA DE CADA CARGA

% CARGA
if Add_CG =='s' 
DSSText.Command =char(strcat('Edit Load.',nome(Barra_C_1),' phases=',num2str (phases(Barra_C_1)),' bus1=', (bus(Barra_C_1)),' kV=',num2str (kV(Barra_C_1)),' kVA=',num2str (Curva_Carga_Gaussiana(1,p1) ),' pf=',num2str (kS(4,Barra_C_1) ),' model=',num2str (model(Barra_C_1)),' Conn=',Conn(Barra_C_1)));
DSSText.Command =char(strcat('Edit Load.',nome(Barra_C_2),' phases=',num2str (phases(Barra_C_2)),' bus1=', (bus(Barra_C_2)),' kV=',num2str (kV(Barra_C_2)),' kVA=',num2str (Curva_Carga_Gaussiana(1,p2) ),' pf=',num2str (kS(4,Barra_C_2) ),' model=',num2str (model(Barra_C_2)),' Conn=',Conn(Barra_C_2)));
DSSText.Command =char(strcat('Edit Load.',nome(Barra_C_3),' phases=',num2str (phases(Barra_C_3)),' bus1=', (bus(Barra_C_3)),' kV=',num2str (kV(Barra_C_3)),' kVA=',num2str (Curva_Carga_Gaussiana(1,p3) ),' pf=',num2str (kS(4,Barra_C_3) ),' model=',num2str (model(Barra_C_3)),' Conn=',Conn(Barra_C_3)));
end

% GERAÇÃO DISTRIBUÍDA
if Add_DG == 's'
DSSText.Command = char(strcat('Edit Generator.',nomeUFV1, ' phases=',num2str (phases(Barra_G_1)),' bus1=',BusUFV1,' kV=',num2str (kV_UFV1),' kW=', num2str (Curva_Geracao_Beta(2,p6)) ,' PF=', num2str (PF_UFV1),' Vpu= ',num2str (VpuUFV1) ,' Model=',char(ModeloUFV1),' Maxkvar=',num2str(MaxkvarUFV1),' Minkvar=',num2str(MinkvarUFV1) ,' Conn=',Conn(Barra_G_1)));
DSSText.Command = char(strcat('Edit Generator.',nomeUFV2, ' phases=',num2str (phases(Barra_G_2)),' bus1=',BusUFV2,' kV=',num2str (kV_UFV2),' kW=', num2str (Curva_Geracao_Beta(2,p7)) ,' PF=', num2str (PF_UFV2),' Vpu= ',num2str (VpuUFV2) ,' Model=',char(ModeloUFV2),' Maxkvar=',num2str(MaxkvarUFV2),' Minkvar=',num2str(MinkvarUFV2) ,' Conn=',Conn(Barra_G_2)));
DSSText.Command = char(strcat('Edit Generator.',nomeUFV3, ' phases=',num2str (phases(Barra_G_3)),' bus1=',BusUFV3,' kV=',num2str (kV_UFV3),' kW=', num2str (Curva_Geracao_Beta(2,p8)) ,' PF=', num2str (PF_UFV3),' Vpu= ',num2str (VpuUFV3) ,' Model=',char(ModeloUFV3),' Maxkvar=',num2str(MaxkvarUFV3),' Minkvar=',num2str(MinkvarUFV3) ,' Conn=',Conn(Barra_G_3)));
end


% RESOLVE O CIRCUITO NO OPENDSS PARA A CARGA i
DSSText.Command =char('Solve');

%% COLETA DAS GRANDEZAS DE INTERESSE - SIMULAÇÃO 64 ITERAÇÕES

% - CORRENTE, TENSÃO E POTENCIA DOS ELEMENTOS DO CIRCUITO - OBTEM A CORRENTE DAS LINHAS DA ITERACAO i
for i=1:size(ElementsName)
clear i_I_Element;
clear i_S_Element;
clear i_U_Element;
clear i_Losses_Element;

i_ElementsName = char(ElementsName(i));  

DSSCircuit.SetActiveElement(i_ElementsName);
i_I_Element(1,:) =DSSElement.CurrentsMagAng;
i_U_Element(1,:)=DSSElement.VoltagesMagAng;
i_S_Element(1,:)=DSSElement.Powers;
i_Losses_Element(1,:)=DSSElement.Losses;

i_I_Element = [i_I_Element, zeros(1,length(vet_gen(1,1:16)) -length(i_I_Element))];
i_S_Element = [i_S_Element, zeros(1,length(vet_gen(1,1:16)) -length(i_S_Element))];
i_U_Element = [i_U_Element, zeros(1,length(vet_gen(1,1:16)) -length(i_U_Element))];
i_Losses_Element = [i_Losses_Element, zeros(1,length(vet_gen(1,1:16)) -length(i_Losses_Element))];

I_Element(i,:)=i_I_Element;
S_Element(i,:)=i_S_Element;
U_Element(i,:)=i_U_Element;
Losses_Element(i,:)=i_Losses_Element;
end

% - TENSÃO - OBTEM O MODULO DA TENSÃO DA ITERAÇÃO i
U_Element_phaseA(:,p) =U_Element(:,1);
U_Element_phaseB(:,p) =U_Element(:,3);
U_Element_phaseC(:,p) =U_Element(:,5);

% - CORRENTE - OBTEM O MODULO DA CORRENTE DA ITERAÇÃO i
I_Element_phaseA(:,p) = I_Element(:,1);
I_Element_phaseB(:,p) = I_Element(:,3);
I_Element_phaseC(:,p) = I_Element(:,5);

% - POTENCIA APARENTE - OBTEM O MODULO DA POTENCIA APARENTE DA ITERAÇÃO i
S_Element_phaseA(:,p) = sqrt(S_Element(:,1).^2 + S_Element(:,2).^2);
S_Element_phaseB(:,p) = sqrt(S_Element(:,3).^2 + S_Element(:,4).^2);
S_Element_phaseC(:,p) = sqrt(S_Element(:,5).^2 + S_Element(:,6).^2);

% - PERDAS NOS ELEMENTOS - OBTEM AS PERDAS ATIVAS E REATIVAS EM CADA ELEMENTO DA ITERAÇÃO i
Losses_Element_Ativas(:,p) = Losses_Element(:,1);
Losses_Element_Reativas(:,p) = Losses_Element(:,2);


p= p+1;

end  % Geração 8
end  % Geração 7
end  % Geração 6
end  % Carga 3
end  % Carga 2
end  % Carga 1

n_iteracoes = p-1
tempo_simulacao = toc

% FIM DO LOOP TEST


else    
%% INICIO DO LOOP

disp('Iniciando o Loop, tempo aproximado de espera em minutos : '); t = Total_Simulacoes*26.8/(729*60) 
disp('... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ...  ... ... ... ... ... ... ... ... ... ... ...  ... ... ... ...');
%________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
% LOOP - CADA PONTO RESPECTIVO A CURVA DE DENSIDADE DE PROBABILIDADE
for p1=1:Npontoscurvacarga % Carga 1
for p2=1:Npontoscurvacarga % Carga 2
for p3=1:Npontoscurvacarga % Carga 3
for p4=1:Npontoscurvacarga % Carga 4
for p5=1:Npontoscurvacarga % Carga 5
for p6=1:Npontoscurvageracao % Carga 6
for p7=1:Npontoscurvageracao % Carga 7
for p8=1:Npontoscurvageracao % Carga 8
for p9=1:Npontoscurvageracao % Carga 9
for p10=1:Npontoscurvageracao % Carga 10
% ACESSA O OPENDSS E AJUSTA O VALOR DA POTENCIA DE CADA CARGA

% CARGA
if Add_CG =='s' 
DSSText.Command =char(strcat('Edit Load.',nome(Barra_C_1),' phases=',num2str (phases(Barra_C_1)),' bus1=', (bus(Barra_C_1)),' kV=',num2str (kV(Barra_C_1)),' kVA=',num2str (Curva_Carga_Gaussiana(1,p1) ),' pf=',num2str (kS(4,Barra_C_1) ),' model=',num2str (model(Barra_C_1)),' Conn=',Conn(Barra_C_1)));
DSSText.Command =char(strcat('Edit Load.',nome(Barra_C_2),' phases=',num2str (phases(Barra_C_2)),' bus1=', (bus(Barra_C_2)),' kV=',num2str (kV(Barra_C_2)),' kVA=',num2str (Curva_Carga_Gaussiana(1,p2) ),' pf=',num2str (kS(4,Barra_C_2) ),' model=',num2str (model(Barra_C_2)),' Conn=',Conn(Barra_C_2)));
DSSText.Command =char(strcat('Edit Load.',nome(Barra_C_3),' phases=',num2str (phases(Barra_C_3)),' bus1=', (bus(Barra_C_3)),' kV=',num2str (kV(Barra_C_3)),' kVA=',num2str (Curva_Carga_Gaussiana(1,p3) ),' pf=',num2str (kS(4,Barra_C_3) ),' model=',num2str (model(Barra_C_3)),' Conn=',Conn(Barra_C_3)));
DSSText.Command =char(strcat('Edit Load.',nome(Barra_C_4),' phases=',num2str (phases(Barra_C_4)),' bus1=', (bus(Barra_C_4)),' kV=',num2str (kV(Barra_C_4)),' kVA=',num2str (Curva_Carga_Gaussiana(1,p4) ),' pf=',num2str (kS(4,Barra_C_4) ),' model=',num2str (model(Barra_C_4)),' Conn=',Conn(Barra_C_4)));
DSSText.Command =char(strcat('Edit Load.',nome(Barra_C_5),' phases=',num2str (phases(Barra_C_5)),' bus1=', (bus(Barra_C_5)),' kV=',num2str (kV(Barra_C_5)),' kVA=',num2str (Curva_Carga_Gaussiana(1,p5) ),' pf=',num2str (kS(4,Barra_C_5) ),' model=',num2str (model(Barra_C_5)),' Conn=',Conn(Barra_C_5)));
end
% GERAÇÃO DISTRIBUÍDA
if Add_DG == 's'
DSSText.Command = char(strcat('Edit Generator.',nomeUFV1, ' phases=',num2str (phases(Barra_G_1)),' bus1=',BusUFV1,' kV=',num2str (kV_UFV1),' kW=', num2str (Curva_Geracao_Beta(2,p6)) ,' PF=', num2str (PF_UFV1),' Vpu= ',num2str (VpuUFV1) ,' Model=',char(ModeloUFV1),' Maxkvar=',num2str(MaxkvarUFV1),' Minkvar=',num2str(MinkvarUFV1) ,' Conn=',Conn(Barra_G_1)));
DSSText.Command = char(strcat('Edit Generator.',nomeUFV2, ' phases=',num2str (phases(Barra_G_2)),' bus1=',BusUFV2,' kV=',num2str (kV_UFV2),' kW=', num2str (Curva_Geracao_Beta(2,p7)) ,' PF=', num2str (PF_UFV2),' Vpu= ',num2str (VpuUFV2) ,' Model=',char(ModeloUFV2),' Maxkvar=',num2str(MaxkvarUFV2),' Minkvar=',num2str(MinkvarUFV2) ,' Conn=',Conn(Barra_G_2)));
DSSText.Command = char(strcat('Edit Generator.',nomeUFV3, ' phases=',num2str (phases(Barra_G_3)),' bus1=',BusUFV3,' kV=',num2str (kV_UFV3),' kW=', num2str (Curva_Geracao_Beta(2,p8)) ,' PF=', num2str (PF_UFV3),' Vpu= ',num2str (VpuUFV3) ,' Model=',char(ModeloUFV3),' Maxkvar=',num2str(MaxkvarUFV3),' Minkvar=',num2str(MinkvarUFV3) ,' Conn=',Conn(Barra_G_3)));
DSSText.Command = char(strcat('Edit Generator.',nomeUFV4, ' phases=',num2str (phases(Barra_G_4)),' bus1=',BusUFV4,' kV=',num2str (kV_UFV4),' kW=', num2str (Curva_Geracao_Beta(2,p9)) ,' PF=', num2str (PF_UFV4),' Vpu= ',num2str (VpuUFV4) ,' Model=',char(ModeloUFV4),' Maxkvar=',num2str(MaxkvarUFV4),' Minkvar=',num2str(MinkvarUFV4) ,' Conn=',Conn(Barra_G_4)));
DSSText.Command = char(strcat('Edit Generator.',nomeUFV5, ' phases=',num2str (phases(Barra_G_5)),' bus1=',BusUFV5,' kV=',num2str (kV_UFV5),' kW=', num2str (Curva_Geracao_Beta(2,p10)) ,' PF=', num2str (PF_UFV5),' Vpu= ',num2str (VpuUFV5) ,' Model=',char(ModeloUFV5),' Maxkvar=',num2str(MaxkvarUFV5),' Minkvar=',num2str(MinkvarUFV5) ,' Conn=',Conn(Barra_G_5)));
end

% RESOLVE O CIRCUITO NO OPENDSS PARA A CARGA i
DSSText.Command =char('Solve');
%% COLETA DAS GRANDEZAS DE INTERESSE

% - CORRENTE, TENSÃO E POTENCIA DOS ELEMENTOS DO CIRCUITO - OBTEM A CORRENTE DAS LINHAS DA ITERACAO i
for i=1:size(ElementsName)
clear i_I_Element;
clear i_S_Element;
clear i_U_Element;
clear i_Losses_Element;

i_ElementsName = char(ElementsName(i));  

DSSCircuit.SetActiveElement(i_ElementsName);
i_I_Element(1,:) =DSSElement.CurrentsMagAng;
i_U_Element(1,:)=DSSElement.VoltagesMagAng;
i_S_Element(1,:)=DSSElement.Powers;
i_Losses_Element(1,:)=DSSElement.Losses;

i_I_Element = [i_I_Element, zeros(1,length(vet_gen(1,1:16)) -length(i_I_Element))];
i_S_Element = [i_S_Element, zeros(1,length(vet_gen(1,1:16)) -length(i_S_Element))];
i_U_Element = [i_U_Element, zeros(1,length(vet_gen(1,1:16)) -length(i_U_Element))];
i_Losses_Element = [i_Losses_Element, zeros(1,length(vet_gen(1,1:16)) -length(i_Losses_Element))];

I_Element(i,:)=i_I_Element;
S_Element(i,:)=i_S_Element;
U_Element(i,:)=i_U_Element;
Losses_Element(i,:)=i_Losses_Element;
end

% - TENSÃO - OBTEM O MODULO DA TENSÃO DA ITERAÇÃO i
U_Element_phaseA(:,p) =U_Element(:,1);
U_Element_phaseB(:,p) =U_Element(:,3);
U_Element_phaseC(:,p) =U_Element(:,5);

% - CORRENTE - OBTEM O MODULO DA CORRENTE DA ITERAÇÃO i
I_Element_phaseA(:,p) = I_Element(:,1);
I_Element_phaseB(:,p) = I_Element(:,3);
I_Element_phaseC(:,p) = I_Element(:,5);

% - POTENCIA APARENTE - OBTEM O MODULO DA POTENCIA APARENTE DA ITERAÇÃO i
S_Element__phaseA(:,p) = sqrt(S_Element(:,1).^2 + S_Element(:,2).^2);
S_Element__phaseB(:,p) = sqrt(S_Element(:,3).^2 + S_Element(:,4).^2);
S_Element__phaseC(:,p) = sqrt(S_Element(:,5).^2 + S_Element(:,6).^2);

% - PERDAS NOS ELEMENTOS - OBTEM AS PERDAS ATIVAS E REATIVAS EM CADA ELEMENTO DA ITERAÇÃO i
Losses_Element_Ativas(:,p) = Losses_Element(:,1);
Losses_Element_Reativas(:,p) = Losses_Element(:,2);


p= p+1;

end  % Carga 10
end  % Carga 9
end  % Carga 8
end  % Carga 7
end  % Carga 6
end  % Carga 5
end  % Carga 4
end  % Carga 3
end  % Carga 2
end  % Carga 1


n_iteracoes = p-1
tempo_simulacao = toc

% FIM DO LOOP



end

%% GRANDEZAS COLETADAS

% Obtidas : 
% i   ) Tensão nas barras (UphaseA_total,UphaseB_total,UphaseC_total)
% ii  ) Corrente nas linhas (IphaseA,IphaseB,IphaseC)
% iii ) Potencia S nas linhas (Slinhas_phaseA,Slinhas_phaseB,Slinhas_phaseC) 
% iv ) Distancia do medidor aos Nós (barras), (DistA,DistB,DistC)

% 1 ) O menor valor de tensão (U) na rede (em pu) 
% 2 ) Trechos de rede com valor de carregamento percentual (em %) maior que 66%.
% 3 ) Carregamento é dado por Icabo/Imaxcabo
% 4 ) Distancia dos Nós ao Medidor

%_____________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
% CARREGAMENTO DE CORRENTE NAS LINHAS DE TRANSMISSÃO 

for(i=4:121)

i_ElementsName = char(ElementsName(i));  
DSSCircuit.SetActiveElement(i_ElementsName);
tipo_cabo = DSSLines.LineCode;

if (tipo_cabo== '1')|(tipo_cabo== '2')|(tipo_cabo== '3')|(tipo_cabo== '4')|(tipo_cabo== '5')|(tipo_cabo== '6')|(tipo_cabo== '7')|(tipo_cabo== '8')
CarregamentoCorrente_Element_phaseA(i,:)=I_Element_phaseA(i,:)/cabo_A_336_4_ACSR;    
CarregamentoCorrente_Element_phaseB(i,:)=I_Element_phaseB(i,:)/cabo_A_336_4_ACSR;    
CarregamentoCorrente_Element_phaseC(i,:)=I_Element_phaseC(i,:)/cabo_A_336_4_ACSR;    

elseif (tipo_cabo=='9')|(tipo_cabo== '10')|(tipo_cabo== '11')
CarregamentoCorrente_Element_phaseA(i,:)=I_Element_phaseA(i,:)/cabo_A_1_0_ACSR;    
CarregamentoCorrente_Element_phaseB(i,:)=I_Element_phaseB(i,:)/cabo_A_1_0_ACSR;    
CarregamentoCorrente_Element_phaseC(i,:)=I_Element_phaseC(i,:)/cabo_A_1_0_ACSR;    

elseif(tipo_cabo== '12')
CarregamentoCorrente_Element_phaseA(i,:)=I_Element_phaseA(i,:)/cabo_S_1_0_AA;    
CarregamentoCorrente_Element_phaseB(i,:)=I_Element_phaseB(i,:)/cabo_S_1_0_AA;    
CarregamentoCorrente_Element_phaseC(i,:)=I_Element_phaseC(i,:)/cabo_S_1_0_AA;    

end
end

%% PLOT
% 
% % stairs(Curva_Carga_Gaussiana(1,:),Curva_Carga_Gaussiana(2,:)) plotar a curva de probabilidade
barra = 91;

% PLOTTING PERFIL DA CORRENTE
    figure(1)
    hist(CarregamentoCorrente_Element_phaseA(barra,:));
    figure(2)
    hist(CarregamentoCorrente_Element_phaseB(barra,:));
    figure(3)
    hist(CarregamentoCorrente_Element_phaseC(barra,:));     

%     % PLOTTING PERFIL DA TENSAO
%     figure(4)
%     hist(U_Element_phaseA(barra,:));
%     figure(5)
%     hist(U_Element_phaseB(barra,:));
%     figure(6)
%     hist(U_Element_phaseC(barra,:));
% 
% %     legend('Phase A','Phase B','Phase C');
% %     title([ 'Voltage Profile ']);
% %     ylabel('Voltage (kV) '); % descrição do eixo Y
% %     xlabel('Iterações i'); % descrição do eixo X
% %     grid on; % colocar grade
% %     hold off
%     
%     
% % PLOTTING PERFIL DA POTENCIA ATIVA
%     figure(7)
%     hist(S_Element_phaseA(barra,:));
%     figure(8)
%     hist(S_Element_phaseB(barra,:));
%     figure(9)
%     hist(S_Element_phaseC(barra,:));
%    
%     
% %     legend('Phase A','Phase B','Phase C');
% %     title([ 'Potencia Ativa Profile ']);
% %     ylabel('Potencia Ativa (kW) '); % descrição do eixo Y
% %     xlabel('Iterações i'); % descrição do eixo X
% %     grid on; % colocar grade
% %     hold off
%     
% % PLOTTING PERFIL DA PERDAS
%     figure(10)
%     hist(Losses_Element_Ativas(barra,:));
%     figure(11)
%     hist(Losses_Element_Reativas(barra,:));
%  
% %     legend('Curva de perdas por iteração');
% %     title([ 'Losses Profile ']);
% %     ylabel('Perdas Ativas (kW)'); % descrição do eixo Y
% %     xlabel('Iteração i'); % descrição do eixo X
% %     grid on; % colocar grade
% %     hold off

%% SALVANDO OS DADOS NO DROPBOX
disp('Salvando simulação...');
save(strcat(n_simulacao,'.mat'));
disp('Salvo');

%% FIM SCRIPT













