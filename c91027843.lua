--海晶乙女の闘海
---@param c Card
function c91027843.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x12b))
	e2:SetValue(c91027843.atkval)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c91027843.immtg)
	e3:SetValue(c91027843.efilter)
	c:RegisterEffect(e3)
	--equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(91027843,1))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(c91027843.eqcon)
	e4:SetTarget(c91027843.eqtg)
	e4:SetOperation(c91027843.eqop)
	c:RegisterEffect(e4)
end
function c91027843.atkval(e,c)
	return 200+c:GetEquipGroup():FilterCount(Card.IsSetCard,nil,0x12b)*600
end
function c91027843.immtg(e,c)
	return c:GetSequence()>4 and c:IsSummonType(SUMMON_TYPE_LINK) and c:GetFlagEffect(91027843)~=0
end
function c91027843.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c91027843.cfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:GetSequence()>4 and c:IsSetCard(0x12b) and c:IsType(TYPE_LINK) and c:IsSummonType(SUMMON_TYPE_LINK)
end
function c91027843.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c91027843.cfilter,1,nil,tp)
end
function c91027843.eqfilter(c)
	return c:IsSetCard(0x12b) and c:IsType(TYPE_LINK) and not c:IsForbidden()
end
function c91027843.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c91027843.eqfilter,tp,LOCATION_GRAVE,0,1,nil) end
	eg:GetFirst():CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
end
function c91027843.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	local ft=math.min((Duel.GetLocationCount(tp,LOCATION_SZONE)),3)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c91027843.eqfilter),tp,LOCATION_GRAVE,0,nil)
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) or ft<=0 or g:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ft)
	if sg and sg:GetCount()>0 then
		local sc=sg:GetFirst()
		while sc do
			Duel.Equip(tp,sc,tc,false,true)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetLabelObject(tc)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(c91027843.eqlimit)
			sc:RegisterEffect(e1)
			sc=sg:GetNext()
		end
		Duel.EquipComplete()
	end
end
function c91027843.eqlimit(e,c)
	return e:GetLabelObject()==c
end
