import classes
from json import load
import numpy as np
import pandas as pd
import torch
from torch.utils.data import DataLoader

with open("cnfg.json") as json_data_file:
    config = load(json_data_file)

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

# dataset dimensions: (2210, 17814)
dataloader = DataLoader(classes.TCGA_Dataset(config['tsv']),
                        batch_size=config['batch'],
                        num_workers=4,
                        shuffle=True)

# create a model from autoencoder class
model = classes.AE3(input_shape=17814).to(device) if \
        config['model'].strip().lower() == 'ae3' else \
        classes.AE7(input_shape=17814).to(device)

# create an Adam optimizer object with learning rate 1e-3
optimizer = torch.optim.Adam(model.parameters(), lr=1e-3)

# mean-squared error loss
criterion = torch.nn.MSELoss()

if config['load']:
    checkpoint = torch.load(config['load'])

    model.load_state_dict(checkpoint['model_state_dict'])
    optimizer.load_state_dict(checkpoint['optimizer_state_dict'])

    ep_loss_dict = checkpoint['epoch_loss_dict']
    loss = checkpoint['loss']
    total_ep = checkpoint['epoch']
else:
    ep_loss_dict = {}
    total_ep = 0

epochs = config['epochs']
for epoch in range(epochs):
    loss = 0
    for i_batch, sample_batched in enumerate(dataloader):
        sample, labels = sample_batched['expression'], sample_batched['cancer']

        # reshape mini-batch data to [N, 17814] matrix; load to active device
        sample = sample.view(-1, 17814).to(device)

        # gradients accumulate on subsequent backward passes; reset them to 0
        optimizer.zero_grad()

        # compute reconstructions
        outputs = model(sample)

        # compute training reconstruction loss
        train_loss = criterion(outputs, sample)

        # compute accumulated gradients
        train_loss.backward()

        # perform parameter update based on current gradients
        optimizer.step()

        # add the mini-batch training loss to epoch loss
        loss += train_loss.item()

    # compute the epoch training loss
    loss = loss / len(dataloader)

    # update epoch-loss table with new loss
    if total_ep:
        ep_loss_dict[epoch + total_ep] = loss
    else:
        ep_loss_dict[epoch] = loss

    # display the epoch training loss
    print("epoch : {}/{}, loss = {:.6f}".format(epoch + 1, epochs, loss))

# update epoch count
total_ep += epochs

if config['save']:
    torch.save({
                'epoch': total_ep,
                'model_state_dict': model.state_dict(),
                'optimizer_state_dict': optimizer.state_dict(),
                'loss': loss,
                'epoch_loss_dict': ep_loss_dict
                }, config['save'])
