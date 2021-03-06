/**
 * Service.h
 *
 * Copyright 2019 mikee47 <mike@sillyhouse.net>
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
 * You should have received a copy of the GNU General Public License along with FlashString.
 * If not, see <https://www.gnu.org/licenses/>.
 *
 ****/

#pragma once

#include "Object.h"
#include "ObjectList.h"
#include "Action.h"
#include "Constants.h"
#include "Urn.h"

#define UPNP_SERVICE_FIELD_MAP(XX)                                                                                     \
	XX(serviceType, required)                                                                                          \
	XX(serviceId, required)                                                                                            \
	XX(SCPDURL, required)                                                                                              \
	XX(controlURL, required)                                                                                           \
	XX(eventSubURL, required)                                                                                          \
	XX(domain, custom)                                                                                                 \
	XX(baseURL, custom)                                                                                                \
	XX(type, custom)                                                                                                   \
	XX(version, custom)

namespace UPnP
{
class Device;
class Service;
using ServiceList = ObjectList<Service>;

/**
 * @brief Represents any kind of device, including a root device
 */
class Service : public ObjectTemplate<Service>
{
public:
	enum class Field {
#define XX(name, req) name,
		UPNP_SERVICE_FIELD_MAP(XX)
#undef XX
			customStart = domain,
		MAX
	};

	RootDevice* getRoot() override;

	void search(const SearchFilter& filter) override;
	bool formatMessage(Message& msg, MessageSpec& ms) override;

	bool onHttpRequest(HttpServerConnection& connection) override;

	virtual String getField(Field desc);

	XML::Node* getDescription(XML::Document& doc, DescType descType) override;

	ItemEnumerator* getList(unsigned index, String& name) override;

	Device* device() const
	{
		return device_;
	}

	/**
	 * @brief An action request has been received
	 * @todo We need to define actions for a service, accessed via enumerator.
	 * We can also then parse the arguments and check for validity, then pass this
	 * information to `invoke()`, which is code generated for each service type.
	 * The user then gets a set of methods to implement for their service.
	 */
	virtual void handleAction(ActionInfo& info) = 0;

private:
	friend class Device;
	void setDevice(Device* device)
	{
		device_ = device;
	}

private:
	Device* device_{nullptr};
	// actionList
	// serviceStateTable
};

} // namespace UPnP

String toString(UPnP::Service::Field field);
