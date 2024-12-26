--偽物のわな
---@param c Card
function c3027001.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c3027001.condition)
	e1:SetTarget(c3027001.target)
	e1:SetOperation(c3027001.activate)
	c:RegisterEffect(e1)
end
function c3027001.cfilter(c,tp)
	return c:IsType(TYPE_TRAP) and c:IsLocation(LOCATION_SZONE) and c:IsControler(tp)
end
function c3027001.condition(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	if ex and tg~=nil and tg:GetCount()==tc and tg:IsExists(c3027001.cfilter,1,e:GetHandler(),tp) then
		e:SetLabelObject(re)
		return true
	else return false end
end
function c3027001.cffilter(c,tp)
	return c:IsFacedown() and c:IsControler(tp)
end
function c3027001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c3027001.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DESTROY_REPLACE)
		e1:SetRange(LOCATION_SZONE)
		e1:SetTarget(c3027001.reptg)
		e1:SetValue(c3027001.repvalue)
		e1:SetOperation(c3027001.repop)
		e1:SetLabelObject(e:GetLabelObject())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function c3027001.repfilter(c,tp)
	return c3027001.cfilter(c,tp) and not c:IsReason(REASON_REPLACE)
end
function c3027001.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return re==e:GetLabelObject() and eg:IsExists(c3027001.repfilter,1,c,tp) end
	local sg=eg:Filter(c3027001.repfilter,c,tp)
	local fg=sg:Filter(c3027001.cffilter,nil,tp)
	if fg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,fg)
	end
	sg:KeepAlive()
	e:SetLabelObject(sg)
	return true
end
function c3027001.repvalue(e,c)
	local g=e:GetLabelObject()
	return g:IsContains(c)
end
function c3027001.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
	local g=e:GetLabelObject()
	g:DeleteGroup()
end
