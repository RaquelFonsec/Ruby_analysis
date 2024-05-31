require 'daru'
require 'csv'
require 'rumale'
require 'gruff'

class TitanicAnalysis
  def self.run
    # Carregar dados
    train_data = Daru::DataFrame.from_csv('lib/assets/train.csv')
    test_data = Daru::DataFrame.from_csv('lib/assets/test.csv')

    # Pré-processamento dos dados
    preprocess_data(train_data, test_data)

    # Realizar Análise Exploratória de Dados (EDA)
    EDA(train_data, test_data)

    # Engenharia de características
    feature_engineering(train_data, test_data)

    # Seleção e treinamento do modelo
    model = train_model(train_data)

    # Fazer previsões
    predictions = model ? make_predictions(model, test_data) : nil

    # Salvar previsões
    save_predictions(predictions, test_data) if predictions

    # Exibir coeficientes do modelo
    display_model_coefficients(model) if model

    puts "Análise concluída e previsões salvas em 'lib/assets/predictions.csv'."
  end

  def self.EDA(train_data, test_data)
    # EDA pode incluir estatísticas resumidas, visualizações de dados, etc.
    # Por exemplo:
    puts "Resumo dos dados de treino:"
    summarize_data(train_data)

    puts "Resumo dos dados de teste:"
    summarize_data(test_data)

    # Análise adicional: Visualização com Gruff
    visualize_survival(train_data)
  end

  def self.summarize_data(data)
    puts "Número de Linhas: #{data.size}"
    puts "Colunas:"
    data.vectors.each do |column|
      puts "  #{column}:"
      unique_values = data[column].uniq
      puts "    Valores Únicos: #{unique_values.size}"
      if unique_values.size <= 10
        puts "    Contagem de Valores:"
        unique_values.each do |value|
          count = data[column].count { |val| val == value }
          puts "      #{value}: #{count}"
        end
      else
        puts "    (Muitos valores únicos para exibir)"
      end
    end
  end

  def self.visualize_survival(train_data)
    num_survived = train_data['Survived'].count { |val| val == 1 }
    num_not_survived = train_data['Survived'].count { |val| val == 0 }

    graph = Gruff::Bar.new
    graph.title = 'Sobreviventes vs Não Sobreviventes'
    graph.labels = { 0 => 'Não Sobreviventes', 1 => 'Sobreviventes' }
    graph.data('Passageiros', [num_not_survived, num_survived])
    graph.write('survivors_vs_non_survivors.png')
  end

  def self.preprocess_data(train_data, test_data)
    # Lidar com valores ausentes para 'Age' nos dados de treino
    train_data['Age'].map! { |age| age.nil? ? train_data['Age'].mean : age }
    # Lidar com valores ausentes para 'Age' nos dados de teste
    test_data['Age'].map! { |age| age.nil? ? test_data['Age'].mean : age }

    # Lidar com valores ausentes para 'Fare' nos dados de treino
    train_data['Fare'].map! { |fare| fare.nil? ? train_data['Fare'].mean : fare }
    # Lidar com valores ausentes para 'Fare' nos dados de teste
    test_data['Fare'].map! { |fare| fare.nil? ? test_data['Fare'].mean : fare }

    # Mapear valores de 'Sex' para numérico nos dados de treino
    train_data['Sex'] = train_data['Sex'].map { |sex| sex == 'male' ? 0 : 1 }
    # Mapear valores de 'Sex' para numérico nos dados de teste
    test_data['Sex'] = test_data['Sex'].map { |sex| sex == 'male' ? 0 : 1 }

    # Mapear valores de 'Embarked' para numérico nos dados de treino
    train_data['Embarked'] = train_data['Embarked'].map { |embarked| embarked == 'S' ? 0 : embarked == 'C' ? 1 : 2 }
    # Mapear valores de 'Embarked' para numérico nos dados de teste
    test_data['Embarked'] = test_data['Embarked'].map { |embarked| embarked == 'S' ? 0 : embarked == 'C' ? 1 : 2 }
  end

  def self.feature_engineering(train_data, test_data)
    # Exemplo: Criar uma nova característica 'FamilySize' combinando 'SibSp' e 'Parch'
    train_data['FamilySize'] = train_data['SibSp'] + train_data['Parch'] + 1
    test_data['FamilySize'] = test_data['SibSp'] + test_data['Parch'] + 1

    # Você pode adicionar mais etapas de engenharia de características conforme necessário
  end

  def self.train_model(train_data)
    # Verificar se as colunas necessárias existem
    required_columns = ['Age', 'Fare', 'Sex', 'Embarked']
    unless required_columns.all? { |col| train_data.vectors.include?(col) }
      raise StandardError, "Colunas necessárias estão ausentes no DataFrame."
    end

    # Preparar recursos e rótulos de treinamento
    x_train = required_columns.map { |col| train_data[col].to_a.map(&:to_f) }.transpose
    y_train = train_data['Survived'].to_a

    # Treinar um modelo de regressão logística
    model = Rumale::LinearModel::LogisticRegression.new
    begin
      model.fit(x_train, y_train)
    rescue => e
      puts "Erro ocorreu durante o treinamento do modelo: #{e.message}"
      puts "Colunas disponíveis no DataFrame: #{train_data.vectors.to_a}"
      return nil
    end

    return model
  end
  
  def self.make_predictions(model, test_data)
    # Selecionar apenas as colunas necessárias para o modelo
    required_columns = ['Age', 'Fare', 'Sex', 'Embarked']
    
    # Verificar se todas as colunas necessárias estão presentes nos dados de teste
    missing_columns = required_columns - test_data.vectors.to_a
    unless missing_columns.empty?
      raise ArgumentError, "As seguintes colunas estão ausentes nos dados de teste: #{missing_columns.join(', ')}"
    end

    # Obter os valores numéricos de cada coluna presente nos dados de teste
    x_test = test_data.map_rows do |row|
      required_columns.map { |col| row[col].to_f }
    end

    # Fazer previsões usando o modelo treinado
    decision_scores = model.decision_function(x_test)

    # Definir um limite para a decisão
    threshold = 0.0

    # Converter a decisão em previsões binárias
    predictions = decision_scores.map { |score| score >= threshold ? 1 : 0 }

    predictions
  end

  def self.save_predictions(predictions, test_data)
    # Salvar previsões em um arquivo CSV
    CSV.open('lib/assets/predictions.csv', 'w') do |csv|
      csv << ['PassengerId', 'Survived']
      test_data.each_row_with_index do |row, idx|
        csv << [row['PassengerId'], predictions[idx]]
      end
    end
  end

  def self.display_model_coefficients(model)
    # Obter os nomes das colunas
    column_names = ['Age', 'Fare', 'Sex', 'Embarked']
    # Obter os coeficientes do modelo
    coefficients = model.weight_vec.to_a

    # Mapear os coeficientes para os nomes das colunas
    feature_coefficients = Hash[column_names.zip(coefficients)]

    # Ordenar os coeficientes pela magnitude (valor absoluto)
    sorted_feature_coefficients = feature_coefficients.sort_by { |_, coef| coef.abs }.reverse

    # Exibir os coeficientes ordenados
    puts "Coeficientes do modelo:"
    sorted_feature_coefficients.each do |feature, coef|
      puts "#{feature}: #{coef}"
    end
  end
end

TitanicAnalysis.run
