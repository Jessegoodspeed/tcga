import torch


class AE(torch.nn.Module):
    def __init__(self, **kwargs):
        super().__init__()
        self.eH0 = torch.nn.Linear(  # encoderHiddden
            in_features=kwargs["input_shape"], out_features=10
        )
        self.eO = torch.nn.Linear(  # encoderOutput
            in_features=10, out_features=10
        )
        self.dH0 = torch.nn.Linear(  # decoderHidden
            in_features=10, out_features=10
        )
        self.dO = torch.nn.Linear(
            in_features=10, out_features=kwargs["input_shape"]
        )

    def forward(self, features):
        a = self.eH0(torch.tanh(features))  # activation
        a = self.eO(torch.tanh(a))
        a = self.dH0(torch.tanh(a))
        return self.dO(torch.tanh(a))
