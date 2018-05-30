describe 'Rubocop_test' do
  it 'check code style' do
    result = system 'bundle exec rubocop --config .rubocop.yml'
    expect(result).to be true
  end
end
