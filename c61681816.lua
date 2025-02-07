--プロパ・ガンダケ
function c61681816.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(61681816,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c61681816.rctg)
	e1:SetOperation(c61681816.rcop)
	c:RegisterEffect(e1)
	--race
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetCondition(c61681816.econ)
	e2:SetValue(c61681816.value)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCondition(c61681816.econ)
	e3:SetTarget(c61681816.etg)
	e3:SetValue(c61681816.tgoval)
	c:RegisterEffect(e3)
end
function c61681816.cfilter(c)
	local race=c:GetOriginalRace()
	return c:IsFaceup() and (race==RACE_BEAST or race==RACE_ROCK or race==RACE_PLANT or race==RACE_INSECT)
end
function c61681816.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c61681816.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c61681816.cfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	local race=0
	while tc do
		race=race|tc:GetOriginalRace()
		tc=g:GetNext()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
	local rc=Duel.AnnounceRace(tp,1,race)
	e:SetLabel(rc)
end
function c61681816.rcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(e:GetLabel())
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(61681816,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
function c61681816.econ(e)
	return e:GetHandler():GetFlagEffect(61681816)>0
end
function c61681816.value(e,c)
	return e:GetHandler():GetRace()
end
function c61681816.etg(e,c)
	return c:IsRace(e:GetHandler():GetRace())
end
function c61681816.tgoval(e,re,rp)
	return rp==1-e:GetHandlerPlayer()
		and re:GetActivateLocation()==LOCATION_MZONE and re:GetHandler():IsRace(e:GetHandler():GetRace())
end
