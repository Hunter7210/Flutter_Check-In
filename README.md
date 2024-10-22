
Projeto FLUTTER 
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
						
						



