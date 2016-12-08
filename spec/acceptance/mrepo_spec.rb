require 'spec_helper_acceptance'

describe 'mrepo class' do

  context 'set show_diff' do
    shell('puppet config set show_diff true', { :acceptable_exit_codes => [0,1] })
  end

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      class { '::mrepo': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe package('mrepo') do
      it { is_expected.to be_installed }
    end

    context 'mrepo apache should be running on the default port' do
      describe command('curl 0.0.0.0:80/') do
        its(:stdout) { should match /mrepo/ }
      end
    end
  end

end
