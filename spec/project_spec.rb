require_relative 'support/spec_helper'

require_relative '../lib/brick_and_mortar/project'
require_relative 'support/network_mocks'

BRICK_STORE = File.expand_path('../.test_brick_store', __FILE__)

describe BrickAndMortar::Project do
  let(:project_root) { File.expand_path('../support/test_files/test_project', __FILE__) }
  let(:project_vendor) { File.join(project_root, 'vendor') }

  before do
    FileUtils.rm_rf BRICK_STORE
    FileUtils.rm_rf project_vendor
  end

  after do
    FileUtils.rm_rf BRICK_STORE
    FileUtils.rm_rf project_vendor
  end

  let(:brickfile) { File.join(project_root, 'Brickfile') }
  let(:patient) { BrickAndMortar::Project.new(brickfile, BRICK_STORE) }

  it 'creates a vendor directory with all bricks linked' do
    File.exist?(project_vendor).must_equal false
    patient.laid?.must_equal false
    patient.project_root.must_equal project_root
    patient.vendor.must_equal project_vendor
    patient.lay!
    patient.laid?.must_equal true
    File.exist?(project_vendor).must_equal true
  end
end
