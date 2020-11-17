/**
 * ServiceClass.h
 *
 * Copyright 2020 mikee47 <mike@sillyhouse.net>
 *
 * This file is part of the Sming UPnP Library
 *
 * This library is free software: you can redistribute it and/or modify it under the terms of the
 * GNU General Public License as published by the Free Software Foundation, version 3 or later.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
 * without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with Sming UPnP.
 * If not, see <https://www.gnu.org/licenses/>.
 *
 ****/

#pragma once

#include "ClassObject.h"
#include "Service.h"

namespace UPnP
{
class DeviceControl;
class ServiceControl;
class DeviceClass;

/**
 * @brief Provides all information required for UPnP to construct a ServiceControl object
 */
class ServiceClass : public ClassObject
{
	friend DeviceControl;

public:
	using List = ObjectList<ServiceClass>;
	using Field = Service::Field;

	ServiceClass(const DeviceClass& deviceClass) : devcls(deviceClass)
	{
	}

	Urn getServiceType() const
	{
		return ServiceUrn(getField(Field::domain), getField(Field::type), version());
	}

	virtual String getField(Field desc) const;

	const ServiceClass* getNext() const
	{
		return reinterpret_cast<const ServiceClass*>(next());
	}

	const DeviceClass& deviceClass() const
	{
		return devcls;
	}

protected:
	virtual ServiceControl* createObject(DeviceControl& device, const ServiceClass& serviceClass) const = 0;

private:
	const DeviceClass& devcls;
};

} // namespace UPnP
