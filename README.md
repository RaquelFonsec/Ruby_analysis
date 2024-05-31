# titanic_analysis

O TitanicAnalysis é uma aplicação de análise de dados e previsão de sobrevivência dos passageiros do Titanic, utilizando técnicas de aprendizado de máquina. Este projeto foi desenvolvido como parte de um estudo sobre ciência de dados e machine learning, utilizando a linguagem de programação Ruby e o framework Ruby on Rails.

Funcionalidades Principais:

Carregamento de Dados: Carrega os conjuntos de dados de treino e teste do Titanic em formato CSV.

Pré-processamento de Dados: Realiza o pré-processamento dos dados, tratando valores ausentes e convertendo dados categóricos em numéricos.

Análise Exploratória de Dados (EDA): Fornece um resumo estatístico dos dados e visualizações para entender a distribuição dos passageiros.

Engenharia de Características: Cria novas características a partir das características existentes para melhorar o desempenho do modelo.

Treinamento de Modelo: Treina um modelo de regressão logística para prever a sobrevivência dos passageiros.

Fazendo Previsões: Usa o modelo treinado para fazer previsões sobre a sobrevivência dos passageiros no conjunto de teste.

Salvando Previsões: Salva as previsões em um arquivo CSV para análise posterior.

Exibindo Coeficientes do Modelo: Exibe os coeficientes do modelo treinado para entender a importância das características.


Instalação e Uso:
git clone https://github.com/RaquelFonsec/titanic-analysis.git

instale as dependências do Ruby usando Bundler

cd titanic-analysis
bundle install

Carregue os conjuntos de dados do Titanic na pasta lib/assets/.

Execute o script principal para executar a análise e fazer previsões:

ruby titanic_analysis.rb

Verifique o arquivo lib/assets/predictions.csv para ver as previsões de sobrevivência.

Requisitos:
Ruby >= 3.0
Gems: daru, csv, rumale, gruff
Contribuição:
Se desejar contribuir com melhorias, correções de bugs ou novas funcionalidades, sinta-se à vontade para enviar um pull request.

Autor: Raquel Fonseca 



