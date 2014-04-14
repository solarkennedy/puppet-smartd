require 'spec_helper'

describe 'megaraid_physical_drives_sata', :type => :fact do
  before(:each) { Facter.clear }

  describe 'on linux' do
    context 'megacli not in path' do
      it do
        Facter.fact(:kernel).stubs(:value).returns('Linux')
        Facter.fact(:megacli).stubs(:value).returns(nil)

        Facter.fact(:megaraid_physical_drives_sata).value.should be_nil
      end
    end

    context 'megacli is broken' do
      it do
        Facter.fact(:kernel).stubs(:value).returns('Linux')
        Facter.fact(:megacli).stubs(:value).returns('/usr/bin/MegaCli')
        Facter.fact(:megaraid_adapters).stubs(:value).returns(nil)

        Facter.fact(:megaraid_physical_drives_sata).value.should be_nil
      end

      it do
        Facter.fact(:kernel).stubs(:value).returns('Linux')
        Facter.fact(:megacli).stubs(:value).returns('/usr/bin/MegaCli')
        Facter.fact(:megaraid_adapters).stubs(:value).returns('1')
        Facter::Util::Resolution.stubs(:exec).with('/usr/bin/MegaCli -PDList -aALL -NoLog').
          returns(nil)

        Facter.fact(:megaraid_physical_drives_sata).value.should be_nil
      end
    end

    context 'no adapters' do
      it do
        Facter.fact(:kernel).stubs(:value).returns('Linux')
        Facter.fact(:megacli).stubs(:value).returns('/usr/bin/MegaCli')
        Facter.fact(:megaraid_adapters).stubs(:value).returns('0')

        Facter.fact(:megaraid_physical_drives_sata).value.should be_nil
      end
    end

    context '1 adapter' do
      it do
        Facter.fact(:kernel).stubs(:value).returns('Linux')
        Facter.fact(:megacli).stubs(:value).returns('/usr/bin/MegaCli')
        Facter.fact(:megaraid_adapters).stubs(:value).returns('1')
        Facter::Util::Resolution.stubs(:exec).with('/usr/bin/MegaCli -PDList -aALL -NoLog').
          returns(File.read(fixtures('megacli', 'pdlistaall')))

        Facter.fact(:megaraid_physical_drives_sata).value.should == '10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,184,185'
      end
    end
  end # on linux

  context 'not on linux' do
    it do
      Facter.fact(:kernel).stubs(:value).returns('Solaris')

      Facter.fact(:megaraid_physical_drives_sata).value.should be_nil
    end
  end # not on linux
end

