app = Proc.new do |env|
  [
    '200',
    { 'Content-Type' => 'text/plain' },
    [ "#{env.inspect}" ]
  ]
end

run app
