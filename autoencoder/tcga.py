import pandas as pd
import torch
from torch.utils.data import Dataset


class TCGA_Dataset(Dataset):
    def __init__(self, tsv_file, transform=None):
        self.data_frame = pd.read_csv(tsv_file, sep='\t', header=0)
        self.tcga_frame = self.data_frame.iloc[:, 1:].T
        self.transform = transform

    def __len__(self):
        return len(self.tcga_frame)

    def __getitem__(self, idx):
        if torch.is_tensor(idx):
            idx = idx.tolist()

        tcga_i = torch.tensor(self.tcga_frame.iloc[idx, :])
        label = self.data_frame.columns[idx].split(sep='.')[0]
        sample = {'expression': tcga_i, 'cancer': label}

        if self.transform:
            sample = self.transform(sample)

        return sample
