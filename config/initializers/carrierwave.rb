CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'
  config.fog_credentials = {
    provider:              'AWS',                        # required
    aws_access_key_id:     Rails.application.credentials.aws[:digitalocean_spaces_key],                        # required unless using use_iam_profile
    aws_secret_access_key: Rails.application.credentials.aws[:digitalocean_spaces_secret],
    #digitalocean_spaces_bucket: Rails.application.credentials.digitalocean_spaces_bucket,
    use_iam_profile:       true,                         # optional, defaults to false
    region:                'nyc3',                  # optional, defaults to 'us-east-1'
    host:                  'nyc3.digitaloceanspaces.com',             # optional, defaults to nil
    endpoint:              'https://nyc3.digitaloceanspaces.com' # optional, defaults to nil
  }


  config.fog_directory  = 'judo'                                      # required
  config.fog_public     = true                                                 # optional, defaults to true
  config.fog_attributes = { cache_control: "public, max-age=#{365.days.to_i}" } # optional, defaults to {}
  # For an application which utilizes multiple servers but does not need caches persisted across requests,
  # uncomment the line :file instead of the default :storage.  Otherwise, it will use AWS as the temp cache store.
  # config.cache_storage = :file
end