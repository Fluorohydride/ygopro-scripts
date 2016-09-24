--古代の歯車機械
--Name change is temporary, needs a proper announce function
function c18486927.initial_effect(c)
	--declare card
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c18486927.dectg)
	e1:SetOperation(c18486927.decop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--name change (temp)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(18486927,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c18486927.nametg)
	e3:SetOperation(c18486927.nameop)
	c:RegisterEffect(e3)
end
function c18486927.dectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	Duel.SetTargetParam(Duel.SelectOption(tp,70,71,72))
end
function c18486927.decop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local opt=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local ct=nil
	if opt==0 then
		ct=TYPE_MONSTER
	elseif opt==1 then
		ct=TYPE_SPELL
	else
		ct=TYPE_TRAP
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetLabel(ct)
	e1:SetCondition(c18486927.actcon)
	e1:SetValue(c18486927.actlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c18486927.actlimit(e,re,tp)
	local ct=e:GetLabel()
	return re:IsActiveType(ct) and not re:GetHandler():IsImmuneToEffect(e)
		and (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER))
end
function c18486927.actcon(e)
	local tc=Duel.GetAttacker()
	local tp=e:GetHandlerPlayer()
	return tc and tc:IsControler(tp)
end
function c18486927.nametg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	--Gadget Order: Green, Red, Yellow, Gold, Silver, Soldier, Hauler, Arms, Driver
	local nt={aux.Stringid(18486927,1),aux.Stringid(18486927,2),aux.Stringid(18486927,3),aux.Stringid(18486927,4),aux.Stringid(18486927,5),
		aux.Stringid(18486927,6),aux.Stringid(18486927,7),aux.Stringid(18486927,8),aux.Stringid(18486927,9)}
	local ct={41172955,86445415,13839120,55010259,29021114,86281779,28002611,47985614,54497620}
	Duel.Hint(HINT_SELECTMSG,tp,564)
	local opt=Duel.SelectOption(tp,nt[1],nt[2],nt[3],nt[4],nt[5],nt[6],nt[7],nt[8],nt[9])+1
	local ac=ct[opt]
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
function c18486927.nameop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(ac)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
