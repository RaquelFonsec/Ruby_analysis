require 'daru'
require 'gruff'

# Carregar os dados do arquivo CSV
data = Daru::DataFrame.from_csv('lib/assets/train.csv')

# Remover linhas onde 'Age' ou 'Fare' são nil
data = data.filter_rows { |row| !row['Age'].nil? && !row['Fare'].nil? }

# Criar o gráfico de dispersão
g = Gruff::Scatter.new
g.title = 'Relação entre Idade e Tarifa (Fare) no Titanic'
g.x_axis_label = 'Idade'
g.y_axis_label = 'Tarifa (Fare)'

# Adicionar os dados ao gráfico
g.dataxy('Todos os Passageiros', data['Age'], data['Fare'])

# Personalizar o gráfico
g.legend_font_size = 16
g.marker_font_size = 16

# Salvar o gráfico como imagem
g.write('scatter_plot.png')

puts "Gráfico de dispersão gerado e salvo como 'scatter_plot.png'."

