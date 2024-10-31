## 📱 Connect Event - App de Check-In em Eventos com Verificação de Localização

### 🎯 **Objetivo do Projeto**
 O Connect Event é um aplicativo inovador projetado para simplificar o check-in digital em eventos, utilizando a geolocalização para garantir a presença dos participantes. Com o Connect Event, os usuários podem confirmar sua entrada de forma rápida e prática, eliminando filas e burocracias. Além disso, ao sair do evento, os participantes têm a oportunidade de avaliar sua experiência, contribuindo para a melhoria contínua dos futuros encontros. A integração com o Firebase garante segurança e eficiência no gerenciamento de dados, tornando cada evento mais interativo e envolvente.

---

### 🛠 **Tecnologias Utilizadas**
   - **Flutter** 🐦: Framework principal para desenvolvimento do aplicativo.
   - **Figma** 🖥️: Para a criação de protótipos.
   - **VS Code** 🖥️: Ambiente de desenvolvimento.
   - **Bluestacks 5** 📱: Emulador Android para testes de interface e funcionalidade.
   - **OpenStreetMaps** 🗺️: Para acessar a localização do evento.
   - **Firebase**🔥: Para acesso ao banco de dados 

---

### 📋 **Funcionalidades Principais**

#### 🔐 Registro e Autenticação
   - **Cadastro de Usuários** 📝: Com opções de cadastro utilizando Nome completo do usuario, Data de Nascimento, CPF, e-mail e senha.
   - **Login Seguro** 🔒: Acesso seguro com autenticação por e-mail/senha.

#### 🌍 Verificação de Localização
   - **Permissões de Localização** 📍: Solicitação de permissão de localização ao usuário.
   - **Geofencing para Check-In** 📏: Ao entrar no raio definido do local do evento, o aplicativo verifica automaticamente se o usuário está apto a fazer o check-in.


#### 🎟️ Check-In no Evento
   - **Confirmação de Check-In** ✅: Usuários podem realizar o check-in ao se aproximarem do local definido.
   - **Avaliação** 📳: Ao sair do raio de localização do evento, abre a tela para a Avaliação.

---

### 🧭 **Arquitetura e Navegação do Aplicativo**

   - **Tela Inicial** 🏠: Exibe os próximos eventos.
   - **Tela de Check-In** 📲: Exibe as informações detalhadas do evento atual, incluindo um botão de check-in que se ativa automaticamente quando o usuário está próximo.
   - **Perfil do Usuário** 👤: Exibe os dados pessoais do usuario.

---

### ⚙️ **Requisitos Técnicos**

#### 🛠  Desenvolvimento 
   -**Flutter** para desenvolvimento da aplicação.

#### 🔌 Back-End e Banco de Dados
   - **Firebase** para autenticação, banco de dados e notificações.

#### 🌐 Geolocalização
   - **API de Localização do OpenStreetMaps** ou equivalente para verificar a posição do usuário em relação ao evento.
   - Geofencing com Flutter usando plugins de localização para integração com o dispositivo.

#### 🧪 Emulação e Testes
   - **Bluestacks 5**: Usado para testar a usabilidade e comportamento da interface.

---

### 🎨 **Design e Experiência do Usuário (UI/UX)**

   - **Intuitividade** 🚀: Simplicidade no acesso às informações de eventos e facilidade de uso no processo de check-in.

  
---

### 🧪 **Testes e Segurança**

   - **Testes de Unidade e de Interface** 🧩: Verificação de todos os componentes e das funcionalidades principais.
   - **Simulação de Localização** 📍: Testes de geofencing para garantir que o check-in só é liberado na área permitida.
   - **Segurança de Dados** 🔒: Autenticação segura, criptografia de dados sensíveis e controle rigoroso de permissões.

---

### ⏱️ **Cronograma do Projeto**

| Fase                       | Descrição                                              | Duração Estimada |
|----------------------------|--------------------------------------------------------|-------------------|
| **Planejamento** 📅        | Definição de requisitos e escopo detalhado             | 1 semana         |
| **Design de Interface** 🎨 | Prototipagem e design das telas                        | 2 semanas        |
| **Desenvolvimento Back-End** 🔧 | Configuração de banco de dados e API de localização | 3 semanas      |
| **Desenvolvimento Front-End** 💻 | Implementação das telas e funcionalidades principais | 4 semanas  |
| **Testes e Debugging** 🧪  | Testes no emulador e ajustes finais                    | 2 semanas        |
| **Lançamento e Feedback** 🚀 | Publicação e coleta de feedbacks iniciais              | 1 semana         |


		App de Check-In em Eventos com Verificação de Localização
			(Para alguma pessoa se cadastrar deve estar no local)
			
			- HomeScreen (Cards contendo os eventos)
			- Cadastro de usuario (NomeUsu, DataNascimentoUsu, CPFUsu, SenhaUsu)
			- Login (CPFUsu, SenhaUsu)
			- Detalhes do evento (NomeEvent, DataHoraEvent, LocalizacaoEvent, StatusEvent) 
			- Check-in do evento - Permitido somente se a pessoa estiver a uma determinada distancia do evento (GeoLocalização)
				o check-in deve estar a principio em um btn que deve ficar desabilitado e ao chegar na distancia minima o btn se abilita



			Aprender:
				- FireBase (DB)
				- GeoLocalização



		            Evento {
		            	NomeEvent,
		            	DataHoraEvent,
		            	LocalizacaoEvent,
		            	StatusEvent,
		            		Usuario{ 
		            			NomeUsu, 
		            			DataNascimentoUsu,
		            			CPFUsu,
		            			SenhaUsu,
		            			Check-in{
		            				LocalizacaoAtualCheck,
		            				StatusCheck
		            				}
		            			}
		            	   }
						
						



