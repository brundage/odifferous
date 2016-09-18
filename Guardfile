guard :rspec,
   all_after_pass: false,
   cmd: 'rspec' do
  watch( 'spec/spec_helper.rb' ) { "spec" }
  watch( %r{^lib/(.+)\.rb$} ) { |m| "spec/odifferous/#{m[1]}_spec.rb" }
  watch( %r{^spec/odifferous/.+_spec\.rb$} )
end
