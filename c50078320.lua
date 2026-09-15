--刻印の調停者
function c50078320.initial_effect(c)
	--Announce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c50078320.condition)
	e1:SetCost(c50078320.cost)
	e1:SetOperation(c50078320.operation)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50078320,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c50078320.regtg)
	e2:SetOperation(c50078320.regop)
	c:RegisterEffect(e2)
end

function c50078320.GetAnnounceFilter(ep,ev,re)
	local code=Duel.GetChainInfo(ev,CHAININFO_TARGET_PARAM)
	local announce_filter=re:GetHandler().announce_filter
	if not announce_filter then
		-- announce_filter not specified
		return {code,OPCODE_ISCODE,OPCODE_NOT}
	end
	local function AddNotCodeCondition(t)
		-- ... and not c:IsCode(code)
		local afilter={table.unpack(t)}
		table.insert(afilter,code)
		table.insert(afilter,OPCODE_ISCODE)
		table.insert(afilter,OPCODE_NOT)
		table.insert(afilter,OPCODE_AND)
		return afilter
	end
	if aux.GetValueType(announce_filter)=="function" then
		-- function form
		local res=announce_filter(re,ep,ev)
		if res==true then
			-- allow any except announced code
			return {code,OPCODE_ISCODE,OPCODE_NOT}
		elseif not res then
			-- cannot be reannounced
			return false
		else
			-- returns a table, so we wrap it
			return AddNotCodeCondition(res)
		end
	else
		-- table form
		return AddNotCodeCondition(announce_filter)
	end
end

function c50078320.condition(e,tp,eg,ep,ev,re,r,rp)
	local ex=Duel.GetOperationInfo(ev,CATEGORY_ANNOUNCE)
	return rp==1-tp and ex and c50078320.GetAnnounceFilter(ep,ev,re)~=false
end
function c50078320.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c50078320.operation(e,tp,eg,ep,ev,re,r,rp)
	local afilter=c50078320.GetAnnounceFilter(ep,ev,re)
	if afilter==false then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp,table.unpack(afilter))
	Duel.ChangeTargetParam(ev,ac)
end
function c50078320.desfilter(c)
	return c:IsFaceup()
end
function c50078320.regtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c50078320.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c50078320.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c50078320.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
end
function c50078320.regop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		tc:RegisterFlagEffect(50078320,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(50078320,1))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetLabelObject(tc)
		e1:SetCondition(c50078320.descon)
		e1:SetOperation(c50078320.desop)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	end
end
function c50078320.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetTurnCount()~=e:GetLabel() and tc:GetFlagEffect(50078320)~=0
end
function c50078320.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Hint(HINT_CARD,0,50078320)
	Duel.Destroy(tc,REASON_EFFECT)
end
