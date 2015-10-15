require 'test_helper'

module PushType
  class NodeFieldTest < ActiveSupport::TestCase

    class TestPage < PushType::Node
      field :page_id, :node
      field :bar_ids, :node, multiple: true, to: 'page', root: 'foo-bar'
    end

    before do
      root    = Page.create FactoryGirl.attributes_for(:node, slug: 'foo-bar')
      @pages  = 4.times.map { Page.create FactoryGirl.attributes_for(:node) }
      @bars   = 2.times.map { Page.create FactoryGirl.attributes_for(:node, parent_id: root.id) }
    end

    let(:node)  { TestPage.create FactoryGirl.attributes_for(:node, page_id: rel.id, bar_ids: @bars.map(&:id)) }
    let(:rel)   { @pages.first }
    let(:foo)   { node.fields[:page_id] }
    let(:bar)   { node.fields[:bar_ids] }

    it { foo.json_primitive.must_equal :string }
    it { foo.template.must_equal 'relation' }
    it { foo.wont_be :multiple? }
    it { foo.label.must_equal 'Page' }
    it { foo.html_options.keys.must_include :multiple }
    it { foo.json_value.must_equal rel.id }
    it { foo.value.must_equal rel.id }
    it { foo.choices.size.must_equal 7 }
    it { foo.choices.map { |c| c[:value] }.must_include rel.id }
    it { foo.relation_name.must_equal 'page' }
    it { foo.relation_class.must_equal Page }

    it { bar.json_primitive.must_equal :array }
    it { bar.must_be :multiple? }
    it { bar.label.must_equal 'Bars' }
    it { bar.json_value.must_equal @bars.map(&:id) }
    it { bar.value.must_equal @bars.map(&:id) }
    it { bar.choices.size.must_equal 3 }
    it { bar.relation_name.must_equal 'bars' }

    it { node.page_id.must_equal rel.id }
    it { node.page.must_equal rel }
    it { node.bar_ids.must_equal @bars.map(&:id) }
    it { node.bars.sort.must_equal @bars.sort }

  end
end