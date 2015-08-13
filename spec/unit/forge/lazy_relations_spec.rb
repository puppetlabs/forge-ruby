require 'spec_helper'

describe PuppetForge::LazyRelations do
    class PuppetForge::V3::Parent < PuppetForge::V3::Base

      lazy :relation, 'Thing'
      lazy :chained, 'Parent'
      lazy_collection :relations, 'Thing'
      lazy_collection :parents, 'Parent'

      def uri
        "/parents/#{slug}"
      end

      def slug
        "1"
      end
    end

    class PuppetForge::V3::Thing < PuppetForge::V3::Base

      # Needed for #inspect
      def uri
        "/things/1"
      end

      # Needed for fetch
      def slug
        "1"
      end

      def standalone_method
        "a/b/c"
      end

      def satisified_dependent_method
        "-#{local}-"
      end

      def unsatisfied_dependent_method
        "-#{remote}-"
      end

      def shadow
        "-#{super}-"
      end

      def remote_shadow
        "-#{super}-"
      end

    end

  let(:base_class) { PuppetForge::V3::Base }
  let(:klass) do |*args|
    PuppetForge::V3::Parent
  end

  let(:related_class) do
    PuppetForge::V3::Thing
  end

  let(:local_data)  { { :id => 1, :local => 'data', :shadow => 'x' } }
  let(:remote_data) { local_data.merge(:remote => 'DATA', :remote_shadow => 'X') }

  describe '.lazy' do
    subject { klass.new(:relation => local_data).relation }

    it do
      should be_a(related_class)
    end

    it 'does not call methods to #inspect' do
      expect(subject).not_to receive(:shadow)
      subject.inspect
    end

    describe 'local attributes' do
      before { expect(related_class).not_to receive(:request) }

      example 'allow access to local attributes' do
        expect(subject.local).to eql('data')
      end

      example 'provide local attributes predicates' do
        expect(subject.local?).to be true
      end

      example 'provide local attributes setters' do
        subject.local = 'foo'
        expect(subject.local).to eql('foo')
      end

      example 'allow access to local standalone methods' do
        expect(subject.standalone_method).to eql('a/b/c')
      end

      example 'allow access to locally satisfiable methods' do
        expect(subject.satisified_dependent_method).to eql('-data-')
      end

      example 'allow `super` access to shadowed attributes' do
        expect(subject.shadow).to eql('-x-')
      end
    end

    describe 'remote attributes' do
      before do
        stub_api_for(base_class) do |stubs|
          stubs.get('/v3/things/1') do
            [ 200, { 'Content-Type' => 'json' }, remote_data ]
          end
        end
      end

      example 'allow access to remote attributes' do
        expect(subject.remote).to eql('DATA')
      end

      example 'provide remote attributes predicates' do
        expect(subject.remote?).to be true
      end

      example 'provide remote attributes setters' do
        subject.remote = 'foo'
        expect(subject.remote).to eql('foo')
      end

      example 'allow multiple instances to access remote attributes' do
        expect(related_class).to receive(:request) \
                     .exactly(9).times \
                     .and_call_original

        9.times do
          subject = klass.new(:relation => local_data).relation
          expect(subject.remote).to eql('DATA')
        end
      end

      example 'allow access to locally unsatisfiable methods' do
        expect(subject.unsatisfied_dependent_method).to eql('-DATA-')
      end

      example 'allow `super` access to shadowed remote attributes' do
        expect(subject.remote_shadow).to eql('-X-')
      end
    end

    describe 'remote relations' do
      before do
        stub_api_for(base_class) do |api|
          api.get('/v3/parents/1') do
            data = { :id => 1, :relation => local_data }
            [ 200, { 'Content-Type' => 'json' }, data ]
          end

          api.get('/v3/things/1') do
            [ 200, { 'Content-Type' => 'json' }, remote_data ]
          end
        end

      end

      subject { klass.new(:chained => { :id => 1 }) }

      example 'allow chained lookups of lazy relations' do
        expect(subject.chained.relation.remote).to eql('DATA')
      end
    end

    describe 'null relations' do
      subject { klass.new(:relation => nil) }

      example 'do not return new instances' do
        expect(subject.relation).to be nil
      end
    end

    describe 'unsatisfiable attributes' do
      before do
        stub_api_for(base_class) do |api|
          api.get('/v3/parents/1') do
            [ 200, { 'Content-Type' => 'json' }, remote_data ]
          end
        end
      end

      subject { klass.new(local_data) }

      example 'raise an exception when accessing an unknown attribute' do
        expect { subject.unknown_attribute }.to raise_error(NoMethodError)
      end
    end
  end

  describe '.lazy_collection' do
    subject { klass.new(:relations => [local_data]).relations.first }

    it { should be_a(related_class) }

    it 'does not call methods to #inspect' do
      expect(subject).not_to receive(:shadow)
      subject.inspect
    end

    describe 'local attributes' do
      before { expect(related_class).not_to receive(:request) }

      example 'allow access to local attributes' do
        expect(subject.local).to eql('data')
      end

      example 'provide local attributes predicates' do
        expect(subject.local?).to be true
      end

      example 'provide local attributes setters' do
        subject.local = 'foo'
        expect(subject.local).to eql('foo')
      end

      example 'allow access to local standalone methods' do
        expect(subject.standalone_method).to eql('a/b/c')
      end

      example 'allow access to locally satisfiable methods' do
        expect(subject.satisified_dependent_method).to eql('-data-')
      end

      example 'allow `super` access to shadowed attributes' do
        expect(subject.shadow).to eql('-x-')
      end
    end

    describe 'remote attributes' do
      before do
        stub_api_for(base_class) do |api|
          api.get('/v3/things/1') do
            [ 200, { 'Content-Type' => 'json' }, remote_data ]
          end
        end
      end

      example 'allow access to remote attributes' do
        expect(subject.remote).to eql('DATA')
      end

      example 'provide remote attributes predicates' do
        expect(subject.remote?).to be true
      end

      example 'provide remote attributes setters' do
        subject.remote = 'foo'
        expect(subject.remote).to eql('foo')
      end

      example 'allow multiple instances to access remote attributes' do
        expect(related_class).to receive(:request) \
                     .exactly(9).times \
                     .and_call_original

        9.times do
          subject = klass.new(:relations => [local_data]).relations.first
          expect(subject.remote).to eql('DATA')
        end
      end

      example 'allow access to locally unsatisfiable methods' do
        expect(subject.unsatisfied_dependent_method).to eql('-DATA-')
      end

      example 'allow `super` access to shadowed remote attributes' do
        expect(subject.remote_shadow).to eql('-X-')
      end
    end

    describe 'remote relations' do
      before do
        stub_api_for(base_class) do |api|
          api.get('/v3/parents/1') do
            data = { :id => 1, :parents => [{ :id => 1, :relation => local_data }] }
            [ 200, { 'Content-Type' => 'json' }, data ]
          end

          api.get('/v3/things/1') do
            [ 200, { 'Content-Type' => 'json' }, remote_data ]
          end
        end

      end

      subject { klass.new(:id => 1) }

      example 'allow chained lookups of lazy relations' do
        expect(subject.parents[0].relation.remote).to eql('DATA')
      end
    end

    describe 'null relations' do
      subject { klass.new(:relations => nil) }

      example 'return an empty list' do
        expect(subject.relations).to be_empty
      end
    end

    describe 'unsatisfiable attributes' do
      before do
        stub_api_for(base_class) do |api|
          api.get('/v3/parents/1') do
            [ 200, { 'Content-Type' => 'json' }, remote_data ]
          end
        end
      end

      subject { klass.new(local_data) }

      example 'raise an exception when accessing an unknown attribute' do
        expect { subject.unknown_attribute }.to raise_error(NoMethodError)
      end
    end
  end
end
