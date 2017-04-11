require 'test_helper'

class DatabaseResourceTest < ActiveSupport::TestCase
  include ResourceTesting

  subject { self.class.described_type.new }

  test '_model_class' do
    assert_nil self.class.described_type._model_class
  end

  test_has_many *%i(games competitions clubs members)

  test 'id' do
    assert_equal 'ifdb', subject.id
  end

  test 'find_by_key' do
    assert_kind_of self.class.described_type, self.class.described_type.find_by_key(nil, {})
  end

  test 'games_fields' do
    assert_equal({ games: %w(title author published ratings) }, subject.games_fields)
  end

  test 'competitions_fields' do
    assert_equal({ competitions: %w(title awarddate desc-summary) }, subject.competitions_fields)
  end

  test 'clubs_fields' do
    assert_equal({ clubs: %w(name listed membership desc) }, subject.clubs_fields)
  end

  test 'members_fields' do
    assert_equal({ members: %w(name location since profile-summary) }, subject.members_fields)
  end

  class DatabaseResource::SerializerTest < ActiveSupport::TestCase
    test_extends ApplicationResource::Serializer

    subject { self.class.described_type.new(DatabaseResource) }

    test 'link_builder' do
      assert_kind_of DatabaseResource::LinkBuilder, subject.link_builder
    end

    test 'omit relationship self links' do
      hash = subject.object_hash(DatabaseResource.new).deep_symbolize_keys
      refute_includes hash[:relationships][:games][:links], :self
    end
  end

  class DatabaseResource::LinkBuilderTest < ActiveSupport::TestCase
    test_extends JSONAPI::LinkBuilder

    subject do
      self.class.described_type.new(base_url: 'http://www.example.com', primary_resource_klass: DatabaseResource)
    end

    test 'self_link' do
      assert_equal 'http://www.example.com', subject.self_link(DatabaseResource.new)
    end
  end
end
