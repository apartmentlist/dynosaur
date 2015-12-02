describe Dynosaur::Utils::OS do
  describe '.structured_ps' do
    let(:ps_str) do
      "  PID TTY           TIME CMD\n" \
      " 5799 ttys000    6:42.43 redis-server\n"
    end

    before do
      allow(Dynosaur::Utils::OS).to receive(:ps).and_return(ps_str)
    end

    it 'includes each downcased header' do
      result = Dynosaur::Utils::OS.structured_ps
      expect(result.length).to eq(1)
      expect(result.first.command).to eq('redis-server')
    end

    context 'when there are multiple processes' do
      let(:ps_str) do
        "  PID TTY           TIME CMD\n" \
        " 5730 ttys000    0:00.54 -bash\n" \
        " 5799 ttys000    6:42.43 redis-server\n"
      end

      it 'returns both processes' do
        result = Dynosaur::Utils::OS.structured_ps
        expect(result.length).to eq(2)
        expect(result[0].command).to eq('-bash')
        expect(result[1].command).to eq('redis-server')
      end
    end
  end
end
