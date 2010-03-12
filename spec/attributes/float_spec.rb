require 'spec_helper'
require 'bigdecimal'

module Arel
  describe "Attributes::Float" do

    before :all do
      @relation = Model.build do |r|
        r.engine Testing::Engine.new
        r.attribute :percentage, Attributes::Float
      end
    end

    def type_cast(val)
      @relation[:percentage].type_cast(val)
    end

    describe "#type_cast" do
      it "returns same value if an float" do
        type_cast(24.01).should eql(24.01)
      end

      it "returns nil if passed nil" do
        type_cast(nil).should be_nil
      end

      it "returns nil if passed empty string" do
        type_cast('').should be_nil
      end

      it "returns float representation of a zero string float" do
        type_cast('0').should eql(0.0)
      end

      it "returns float representation of a positive string integer" do
        type_cast('24').should eql(24.0)
      end

      it "returns float representation of a positive string integer with spaces" do
        type_cast('  24').should eql(24.0)
        type_cast('24  ').should eql(24.0)
      end

      it "returns float representation of a negative string float" do
        type_cast('-24.23').should eql(-24.23)
      end

      it "returns float representation of a negative string integer with spaces" do
        type_cast('-24 ').should eql(-24.0)
        type_cast(' -24').should eql(-24.0)
      end

      it "returns integer representation of a zero string float" do
        type_cast('0.0').should eql(0.0)
      end

      it "returns integer representation of a positive string float" do
        type_cast('24.35').should eql(24.35)
      end

      it "returns integer representation of a positive string float with spaces" do
        type_cast(' 24.35').should eql(24.35)
        type_cast('24.35 ').should eql(24.35)
      end

      it "returns integer representation of a negative string float" do
        type_cast('-24.35').should eql(-24.35)
      end

      it "returns integer representation of a negative string float with spaces" do
        type_cast(' -24.35 ').should eql(-24.35)
      end

      it "returns integer representation of a zero string float, with no leading digits" do
        type_cast('.0').should eql(0.0)
      end

      it "returns integer representation of a zero string float, with no leading digits with spaces" do
        type_cast(' .0').should eql(0.0)
      end

      it "returns integer representation of a positive string float, with no leading digits" do
        type_cast('.41').should eql(0.41)
      end

      it "returns integer representation of a zero float" do
        type_cast(0.0).should eql(0.0)
      end

      it "returns integer representation of a positive float" do
        type_cast(24.35).should eql(24.35)
      end

      it "returns integer representation of a negative float" do
        type_cast(-24.35).should eql(-24.35)
      end

      it "returns integer representation of a zero decimal" do
        type_cast(BigDecimal('0.0')).should eql(0.0)
      end

      it "returns integer representation of a positive decimal" do
        type_cast(BigDecimal('24.35')).should eql(24.35)
      end

      it "returns integer representation of a negative decimal" do
        type_cast(BigDecimal('-24.35')).should eql(-24.35)
      end

      [ Object.new, true, '00.0', '0.', 'string' ].each do |value|
        it "raises exception when attempting type_cast of non-numeric value #{value.inspect}" do
          lambda do
            type_cast(value)
          end.should raise_error(TypecastError, /could not typecast/)
        end
      end
    end
  end
end