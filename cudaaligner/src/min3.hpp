/*
* Copyright (c) 2019, NVIDIA CORPORATION.  All rights reserved.
*
* NVIDIA CORPORATION and its licensors retain all intellectual property
* and proprietary rights in and to this software, related documentation
* and any modifications thereto.  Any use, reproduction, disclosure or
* distribution of this software and related documentation without an express
* license agreement from NVIDIA CORPORATION is strictly prohibited.
*/

#pragma once

namespace claragenomics
{

namespace cudaaligner
{
template <typename T>
inline T const& min3(T const& t1, T const& t2, T const& t3)
{
    return std::min(t1, std::min(t2, t3));
}

} // namespace cudaaligner
} // namespace claragenomics
