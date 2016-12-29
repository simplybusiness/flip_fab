module FlipFab
  describe Persistence do
    let(:feature_name) { :example_test }
    let(:context)      { double(:context) }
    subject { described_class.new feature_name, context }

    describe '.new' do
      it 'assigns the feature name' do
        expect(subject.feature_name).to eq(:example_test)
      end

      it 'assigns the context' do
        expect(subject.context).to eq(context)
      end
    end

    describe '#read' do
      it 'is not implemented' do
        expect { subject.read }.to raise_error NotImplementedError
      end
    end

    describe '#write' do
      it 'is not implemented' do
        expect { subject.write feature_name }.to raise_error NotImplementedError
      end
    end
  end
end
