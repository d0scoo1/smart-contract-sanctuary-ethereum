// SPDX-License-Identifier: GPL-3.0

/// @title The BeansToken pseudo-random seed generator

/*********************************                                         
,-----.  ,------.  ,---.  ,--.  ,--. ,---.   
|  |) /_ |  .---' /  O  \ |  ,'.|  |'   .-'  
|  .-.  \|  `--, |  .-.  ||  |' '  |`.  `-.  
|  '--' /|  `---.|  | |  ||  | `   |.-'    | 
`------' `------'`--' `--'`--'  `--'`-----'                                                       
*********************************/

pragma solidity ^0.8.6;

import { IBeansSeeder } from "IBeansSeeder.sol";
import { IBeansDescriptor } from "IBeansDescriptor.sol";

contract BeansSeeder is IBeansSeeder {

    function generateRandomSelection(uint256 beanId, uint256 itemCount, uint256 randy) view public returns (uint256 selectionId) {
        uint256 pseudorandomness = uint256(
            keccak256(abi.encodePacked((block.number - 1), beanId))
        );

        return(uint256(uint256(pseudorandomness >> randy) % itemCount));

    }

    /**
     * @notice Generate a pseudo-random Noun seed using the previous blockhash and noun ID.
     */
    // prettier-ignore
    function generateSeed(uint256 nounId, IBeansDescriptor descriptor) public view override returns (Seed memory) {
      
        uint256 classOneId = generateRandomSelection(nounId, descriptor.classOneCount(), 1);
        uint256 classTwoId = generateRandomSelection(nounId, descriptor.classTwoCount(), 44);
        uint256 sizeId = generateRandomSelection(nounId, 2, 96);
        uint256 helmetLibId = descriptor.classHelmetLibraryCount(sizeId);
        uint256 helmetLibraryId = generateRandomSelection(nounId, helmetLibId, 144); 
        uint256 helmetId = generateRandomSelection(nounId, descriptor.classHelmetCount(sizeId, helmetLibraryId), 144); 
        
        uint256 gearLibraryId = generateRandomSelection(nounId, descriptor.classGearLibraryCount(), 50); 
        uint256 gearId = generateRandomSelection(nounId, descriptor.classGearCount(gearLibraryId), 30); 
        
        uint256 vibeId = generateRandomSelection(nounId, descriptor.classVibeCount(), 1);

        return Seed({
            classOne: classOneId,
            classTwo: classTwoId,
            size: sizeId,
            helmetLib: helmetLibraryId,
            helmet: helmetId,
            gearLib: gearLibraryId,
            gear: gearId,
            vibe: vibeId
        });
    }
}

// SPDX-License-Identifier: GPL-3.0

/// @title Interface for BeansSeeder

/*********************************
 * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ *
 * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ *
 * ░░░░░░█████████░░█████████░░░ *
 * ░░░░░░██░░░████░░██░░░████░░░ *
 * ░░██████░░░████████░░░████░░░ *
 * ░░██░░██░░░████░░██░░░████░░░ *
 * ░░██░░██░░░████░░██░░░████░░░ *
 * ░░░░░░█████████░░█████████░░░ *
 * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ *
 * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ *
 *********************************/

pragma solidity ^0.8.6;

import { IBeansDescriptor } from "IBeansDescriptor.sol";

interface IBeansSeeder {
    struct Seed {
        uint256 classOne;
        uint256 classTwo;
        uint256 size;
        uint256 helmetLib;
        uint256 helmet;
        uint256 gearLib;
        uint256 gear;
        uint256 vibe;

    }

    function generateSeed(uint256 beanId, IBeansDescriptor descriptor) external view returns (Seed memory);
}

// SPDX-License-Identifier: GPL-3.0

/// @title Interface for BeansDescriptor

/*********************************
 * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ *
 * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ *
 * ░░░░░░█████████░░█████████░░░ *
 * ░░░░░░██░░░████░░██░░░████░░░ *
 * ░░██████░░░████████░░░████░░░ *
 * ░░██░░██░░░████░░██░░░████░░░ *
 * ░░██░░██░░░████░░██░░░████░░░ *
 * ░░░░░░█████████░░█████████░░░ *
 * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ *
 * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ *
 *********************************/

pragma solidity ^0.8.6;

import { IBeansSeeder } from "IBeansSeeder.sol";

interface IBeansDescriptor {
    
    // gets the libray for the item and the item count of the specific library 
    
    function classOneCount() external view returns (uint256); //yes

    function classTwoCount() external view returns (uint256); //yes

    function classSizeCount() external view returns (uint256);

    function classHelmetLibraryCount(uint256 libIndex) external view returns (uint256);

    function classHelmetCount(uint256 sizeIndex, uint256 libraryIndex) external view returns (uint256);

    function classGearLibraryCount() external view returns (uint256);

    function classGearCount(uint256 libraryIndex) external view returns (uint256);

    function classVibeCount() external view returns (uint256);

    function tokenURI(uint256 tokenId, IBeansSeeder.Seed memory seed) external view returns (string memory);

    function dataURI(uint256 tokenId, IBeansSeeder.Seed memory seed) external view returns (string memory);


}