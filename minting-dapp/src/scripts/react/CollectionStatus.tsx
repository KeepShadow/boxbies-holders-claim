import React from 'react';
import { ethers, BigNumber } from 'ethers'

interface Props {
  userAddress: string|null;
  userClaimAmount: string|null;
  isPaused: boolean;
  isUserInWhitelist: boolean;
}

interface State {
}

const defaultState: State = {
};

export default class CollectionStatus extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props);

    this.state = defaultState;
  }

  private isSaleOpen(): boolean
  {
    return (!this.props.isPaused) /* && !this.props.isSoldOut //verify if it is claimed already */;
  }

  render() {
    return (
      <>
        <div className="collection-status">
          <div className="user-address">
            <span className="label">Wallet address:</span>
            <span className="address">{this.props.userAddress}</span>
          </div>
          
          {<div className="supply">
            <span className="label">Available to Claim</span>
            {this.props.userClaimAmount}
          </div>}

          <div className="current-sale">
            <span className="label">Claim status</span>
            {this.isSaleOpen() ?
              <>
                {this.props.isPaused ? 'Only Holders' : 'Open'}
              </>
              :
              'Closed'
            }
          </div>
        </div>
      </>
    );
  }
}
