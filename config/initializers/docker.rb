require 'docker'

cert_path = File.expand_path ENV['DOCKER_CERT_PATH']

Docker.options[:client_cert] = File.join(cert_path, 'cert.pem')
Docker.options[:client_key]  = File.join(cert_path, 'key.pem')
Docker.options[:ssl_ca_file] = File.join(cert_path, 'ca.pem')

Docker.options[:scheme]      = 'https'
