module Setup
  class Configuration
    include CenitUnscoped
    include Setup::Singleton
    include RailsAdmin::Models::Setup::ConfigurationAdmin

    build_in_data_type

    deny :all

    # Data Types
    has_and_belongs_to_many :ecommerce_data_types, class_name: Setup::DataType.to_s, inverse_of: nil
    belongs_to :email_data_type, class_name: Setup::DataType.to_s, inverse_of: nil

    # Home Sections
    field :social_networks, type: Array, default: -> { default_social_networks }
    field :home_services_menu, type: Array, default: -> { default_home_services_menu }
    field :home_services, type: Array, default: -> { default_home_services}
    field :home_explore_menu, type: Array, default: -> { default_home_explore_menu }
    field :home_integrations, type: Array, default: -> { default_home_integrations }
    field :home_features, type: Array, default: -> { default_home_features }

    def warnings
      @warnings ||= []
    end

    before_save :check_eccomerce_data_types, :check_email_data_type

    def check_eccomerce_data_types
      ecommerce_data_types.where(:origin.ne => :shared).each do |data_type|
        warnings << "eCommerce data type #{data_type.custom_title} is not shared"
      end
      errors.blank?
    end

    def check_email_data_type
      warnings << "Email data type #{email_data_type.custom_title} is not shared" unless email_data_type.nil? || email_data_type.origin == :shared
      errors.blank?
    end

    def default_social_networks
      [
        { name: 'Linkedin', url: 'https://www.linkedin.com/company/cenit-io', icon: 'fa-linkedin' },
        { name: 'Facebook', url: 'https://www.facebook.com/cenit.io', icon: 'fa-facebook' },
        { name: 'Twitter', url: 'https://www.twitter.com/cenit_io', icon: 'fa-twitter' },
        { name: 'Youtube', url: 'http://www.youtube.com/channel/UC7JVcEmA3BkiR2SZ_lx5lyA', icon: 'fa-youtube' }
      ]
    end

    def default_home_services_menu
      [
        { title: 'Data', url: '/data/dashboard', icon: 'fa fa-cubes', description: 'Definitions - Files - Objects' },
        { title: 'Workflows', url: '/workflows/dashboard', icon: 'fa fa-cogs', description: 'Notifications - Flows - Email Channels - Data Events' },
        { title: 'Transforms', url: '/transforms/dashboard', icon: 'fa fa-random', description: 'Templates - Parsers - Converters - Updaters' },
        { title: 'Gateway', url: '/gateway/dashboard', icon: 'fa fa-hdd-o', description: 'API Specs - OpenAPI Directory - Connectors - Security' },
        { title: 'Integrations', url: '/integrations/dashboard', icon: 'fa fa-puzzle-piece', description: 'Collections - Shared Collections' },
        { title: 'Compute', url: '/compute/dashboard', icon: 'fa fa-cog', description: 'Algorithms - Applications - Snippets - Filters- Notebooks' },
        { title: 'eCcommerce', url: '/ecommerce/dashboard', icon: 'fa fa-shopping-cart', description: 'Products - Inventories - Carts - Orders - Shipments' },
        { title: 'Security', url: '/security/dashboard', icon: 'fa fa-shield', description: 'Remote Clients - Providers - OAuth 2.0 - Authorizations' }
      ]
    end

    def default_home_explore_menu
      [
        { title: 'Shared Collections', url: '/cross_shared_collection', icon: ' fa fa-puzzle-piece', description: 'Data description' },
        { title: 'Applications', url: '/application', icon: 'fa fa-laptop', description: 'Data description' },
        { title: 'Open Api Directory', url: '/open_api_directory', icon: 'fa fa-book', description: 'Data description' },
        { title: 'Notebooks', url: '/notebook', icon: 'fa fa-list', description: 'Data description' }
      ]
    end

    def default_home_services
      [
        { name: 'Sales', icon: 'fa fa-shopping-cart', desc: 'Integrate and manage all your sale channels in only one site: Cenit IO' },
        { name: 'Marketing', icon: 'fa fa-bullhorn', desc: 'Place your products in the most popular ecommerce platforms with a few clicks.' },
        { name: 'Support', icon: 'fa fa-life-ring', desc: 'Enhance support with faster, more efficient ticket resolution and minimize churn.' },
        { name: 'Finances', icon: 'fa fa-money', desc: 'Accelerate order-to-cash, billing and payment processes.' },
        { name: 'Bussiness Operations', icon: 'fa fa-sitemap', desc: 'Supercharge productivity across teams with automated workflows.' },
        { name: 'Human Resources', icon: 'fa fa-users', desc: 'Streamline your HR processes from hire to retire. ' }
      ]
    end

    def default_home_integrations
      %w(aftership amazon asana bigcommerce bronto desk ebay exact_target jirafe magento mailchimp mandrill netsuite odoo oscommerce ql quickbooks sf shipstation shipwire square trello woocommerce zendesk)
    end

    def default_home_features
      [
        { name: 'Backendless', icon: 'fa-mobile', color: 'brown', desc: 'After create a new Data Type using a JSON Schema is generated on the fly a complete REST API and a CRUD UI to manage the data. Useful for mobile backend and API services.' },
        { name: 'Routing and orchestration', icon: 'fa-cogs', color: 'yellow', desc: 'Enables to create multistep integration flows by composing atomic integration functionality (such as connection, transformation, data event, schedule, webhook and flow).' },
        { name: 'Data integration', icon: 'fa-cubes', color: 'green', desc: 'Includes data validation, transformation, mapping, and data quality. Exchange support for multiple data formats (JSON, XML, ASN), data standards (EDIFACT, X12, UBL) and communication protocol connectors (HTTP(S), FTP, SFTP, SCP).' },
        { name: 'Integration scenarios', icon: 'fa-cloud', color: 'blue', desc: 'Cloud Service Integration, for Publication and Management of APIs, Mobile Application Integration, to support Business to Business, Application and Data Integration needs.' },
        { name: 'Third party service integrations', icon: 'fa-share-alt', color: 'purple', desc: 'Directory for OpenAPI Spec (Swagger) and Shared Collections - social feature to share integration settings - to connect services as ERP / Fulfilment / Marketing / Communication.' },
        { name: 'Multi-tenants', icon: 'fa-users', color: 'orange', desc: 'Logical tenant isolation in a physically shared context.Management and control of security, privacy and compliance. Configuration, customization and version control.' }
      ]
    end
  end
end
