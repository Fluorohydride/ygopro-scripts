--急き兎馬
--not fully implemented
function c19636995.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetTargetRange(POS_FACEUP_ATTACK,0)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,19636995)
	e1:SetCondition(c19636995.hspcon)
	e1:SetValue(c19636995.hspval)
	c:RegisterEffect(e1)
	--self destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19636995,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_CUSTOM+19636995)
	e2:SetTarget(c19636995.destg)
	e2:SetOperation(c19636995.desop)
	c:RegisterEffect(e2)
	--custom EVENT_PLACED
	local e2a=Effect.CreateEffect(c)
	e2a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2a:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2a:SetRange(LOCATION_MZONE)
	e2a:SetCode(EVENT_ADJUST)
	e2a:SetOperation(c19636995.plchk)
	c:RegisterEffect(e2a)
	--direct attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(19636995,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c19636995.datop)
	c:RegisterEffect(e3)
end
function c19636995.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=0x1f
	local lg=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	for tc in aux.Next(lg) do
		zone=bit.band(zone,bit.bnot(tc:GetColumnZone(LOCATION_MZONE,0,0,tp)))
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c19636995.hspval(e,c)
	local tp=c:GetControler()
	local zone=0x1f
	local lg=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	for tc in aux.Next(lg) do
		zone=bit.band(zone,bit.bnot(tc:GetColumnZone(LOCATION_MZONE,0,0,tp)))
	end
	return 0,zone
end
function c19636995.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c19636995.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
function c19636995.plfilter(c)
	return not c:IsStatus(STATUS_SUMMONING) and not c:IsStatus(STATUS_SUMMON_DISABLED)
end
function c19636995.gfilter(c,g)
	return not g:IsContains(c)
end
function c19636995.plchk(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup():Filter(c19636995.plfilter,nil)
	if c:GetFlagEffect(19636996)==0 or c:GetFlagEffectLabel(19636996)~=c:GetSequence() then
		c:ResetFlagEffect(19636996)
		c:RegisterFlagEffect(19636996,RESET_EVENT+0x1fd0000,0,1,c:GetSequence())
		cg:KeepAlive()
		e:SetLabelObject(cg)
	elseif cg:IsExists(c19636995.gfilter,1,nil,e:GetLabelObject()) then
		cg:KeepAlive()
		e:SetLabelObject(cg)
		Duel.RaiseSingleEvent(c,EVENT_CUSTOM+19636995,e,0,0,0,0)
	end
end
function c19636995.datop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(math.ceil(c:GetBaseAttack()/2))
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DIRECT_ATTACK)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
end
