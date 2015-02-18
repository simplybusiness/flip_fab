module FlipFab
  describe ContextualFeature do
    let(:default)              { :disabled }
    let(:persistence_adapters) { [TestPersistence] }
    let(:feature)              { Feature.new :example_feature, { default: default, persistence_adapters: persistence_adapters } }
    let(:feature_states)       {{ example_feature: :enabled }}
    let(:context)              { TestContext.new feature_states }
    subject{ described_class.new feature, context }

    describe '.new' do

      it 'assigns the feature' do
        expect(subject.feature).to eq(feature)
      end

      it 'assigns the context' do
        expect(subject.context).to eq(context)
      end
    end

    describe '#enabled?' do

      context 'when the feature is enabled in the adapter' do
        let(:feature_states) {{ example_feature: :enabled }}

        it 'returns true' do
          expect(subject.enabled?).to be_truthy
        end
      end

      context 'when the feature is disabled in the adapter' do
        let(:feature_states) {{ example_feature: :disabled }}

        it 'returns false' do
          expect(subject.enabled?).to be_falsey
        end
      end

      context 'when the feature is not specified in the adapter' do
        let(:feature_states) {{ }}

        context 'when the default is :enabled' do
          let(:default) { :enabled }

          it 'returns true' do
            expect(subject.enabled?).to be_truthy
          end
        end

        context 'when the default is :disabled' do
          let(:default) { :disabled }

          it 'returns false' do
            expect(subject.enabled?).to be_falsey
          end
        end
      end
    end

    describe '#disabled?' do

      context 'when #enabled? returns true' do
        let(:feature_states) {{ example_feature: :enabled }}

        it 'returns false' do
          expect(subject.disabled?).to be_falsey
        end
      end

      context 'when #enabled? returns false' do
        let(:feature_states) {{ example_feature: :disabled }}

        it 'returns true' do
          expect(subject.disabled?).to be_truthy
        end
      end
    end

    describe '#enable' do

      context 'when there is a persistence adapter' do
        let(:persistence_adapters) { [TestPersistence] }

        context 'and the persistence adapter has the same state' do
          let(:feature_states) {{ example_feature: :enabled }}

          it 'does not change the state of the feature' do
            expect{subject.enable}.not_to change{subject.enabled?}.from(true)
          end
        end

        context 'and the persistence adapter has the opposite state' do
          let(:feature_states) {{ example_feature: :disabled }}

          it 'changes the state of the feature' do
            expect{subject.enable}.to change{subject.enabled?}.from(false).to(true)
          end

          it 'persists the state in the adapter' do
            expect_any_instance_of(TestPersistence).to receive(:write).with(:enabled)
            subject.enable
          end
        end

        context 'and the persistence adapter has no state' do
          let(:feature_states) {{ }}

          context 'and the feature is disabled' do
            let(:default) { :disabled }

            it 'changes the state of the feature' do
              expect{subject.enable}.to change{subject.enabled?}.from(false).to(true)
            end

            it 'persists the state in the adapter' do
              expect_any_instance_of(TestPersistence).to receive(:write).with(:enabled)
              subject.enable
            end
          end

          context 'and the feature is enabled' do
            let(:default) { :enabled }

            it 'does not change the state of the feature' do
              expect{subject.enable}.not_to change{subject.enabled?}.from(true)
            end

            it 'persists the state in the adapter' do
              expect_any_instance_of(TestPersistence).to receive(:write).with(:enabled)
              subject.enable
            end
          end
        end

        context 'when there is not a persistence adapter' do
          let(:persistence_adapters) { [] }

          context 'and the feature is enabled' do
            let(:default) { :enabled }

            it 'does not change the state of the feature' do
              expect{subject.enable}.not_to change{subject.enabled?}.from(true)
            end
          end

          context 'and the feature is disabled' do
            let(:default) { :disabled }

            it 'changes the state of the feature' do
              expect{subject.enable}.to change{subject.enabled?}.from(false).to(true)
            end
          end
        end
      end
    end


    describe '#disable' do

      context 'when there is a persistence adapter' do
        let(:persistence_adapters) { [TestPersistence] }

        context 'and the persistence adapter has the same state' do
          let(:feature_states) {{ example_feature: :disabled }}

          it 'does not change the state of the feature' do
            expect{subject.disable}.not_to change{subject.disabled?}.from(true)
          end
        end

        context 'and the persistence adapter has the opposite state' do
          let(:feature_states) {{ example_feature: :enabled }}

          it 'changes the state of the feature' do
            expect{subject.disable}.to change{subject.disabled?}.from(false).to(true)
          end

          it 'persists the state in the adapter' do
            expect_any_instance_of(TestPersistence).to receive(:write).with(:disabled)
            subject.disable
          end
        end

        context 'and the persistence adapter has no state' do
          let(:feature_states) {{ }}

          context 'and the feature is enabled' do
            let(:default) { :enabled }

            it 'changes the state of the feature' do
              expect{subject.disable}.to change{subject.disabled?}.from(false).to(true)
            end

            it 'persists the state in the adapter' do
              expect_any_instance_of(TestPersistence).to receive(:write).with(:disabled)
              subject.disable
            end
          end

          context 'and the feature is disabled' do
            let(:default) { :disabled }

            it 'does not change the state of the feature' do
              expect{subject.disable}.not_to change{subject.disabled?}.from(true)
            end

            it 'persists the state in the adapter' do
              expect_any_instance_of(TestPersistence).to receive(:write).with(:disabled)
              subject.disable
            end
          end
        end

        context 'when there is not a persistence adapter' do
          let(:persistence_adapters) { [] }

          context 'and the feature is disabled' do
            let(:default) { :disabled }

            it 'does not change the state of the feature' do
              expect{subject.disable}.not_to change{subject.disabled?}.from(true)
            end
          end

          context 'and the feature is enabled' do
            let(:default) { :enabled }

            it 'changes the state of the feature' do
              expect{subject.disable}.to change{subject.disabled?}.from(false).to(true)
            end
          end
        end
      end
    end
  end
end

class TestContext

  attr_reader :feature_states

  def initialize feature_states
    @feature_states = feature_states
  end
end

class TestPersistence < FlipFab::Persistence

  def initialize feature_name, context
    super
  end

  def read
    context.feature_states[feature_name]
  end

  def write value
    context.feature_states[feature_name] = value
  end
end
