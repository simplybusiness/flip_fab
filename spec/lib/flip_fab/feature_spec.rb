module FlipFab
  describe Feature do
    let(:name) { :example_test }
    let(:options) { { default: :enabled, persistence_adapters: [] } }
    subject { described_class.new name, options }

    describe '.new' do
      it 'assigns the name' do
        expect(subject.name).to eq(:example_test)
      end

      it 'assigns the default' do
        expect(subject.default).to eq(:enabled)
      end

      it 'assigns the persistence adapters' do
        expect(subject.persistence_adapters).to eq([])
      end

      context 'when the default is not provided' do
        let(:options) { {} }

        it 'assigns the default to :disabled' do
          expect(subject.default).to eq(:disabled)
        end
      end

      context 'when the persistence adapters are not provided' do
        let(:options) { {} }

        it 'uses a cookie adapter' do
          expect(subject.persistence_adapters).to eq([CookiePersistence])
        end
      end
    end

    describe '#enabled?' do
      context 'when the feature is enabled' do
        let(:options) { { default: :enabled, persistence_adapters: [] } }

        it 'returns true' do
          expect(subject.enabled?).to be_truthy
        end
      end

      context 'when the feature is disabled' do
        let(:options) { { default: :disabled, persistence_adapters: [] } }

        it 'returns false' do
          expect(subject.enabled?).to be_falsey
        end
      end
    end

    describe '#disabled?' do
      context 'when the feature is disabled' do
        let(:options) { { default: :disabled, persistence_adapters: [] } }

        it 'returns true' do
          expect(subject.disabled?).to be_truthy
        end
      end

      context 'when the feature is enabled' do
        let(:options) { { default: :enabled, persistence_adapters: [] } }

        it 'returns false' do
          expect(subject.disabled?).to be_falsey
        end
      end
    end

    describe '#with_context' do
      let(:context) { double(:context) }

      it 'returns a contextual feature' do
        expect(subject.with_context(context)).to be_a ContextualFeature
        expect((subject.with_context context).feature).to eq(subject)
        expect((subject.with_context context).context).to eq(context)
      end
    end
  end
end
