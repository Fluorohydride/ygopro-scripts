--遮攻カーテン
function c53167658.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c53167658.reptg1)
	e2:SetValue(c53167658.repval)
	e2:SetOperation(c53167658.repop1)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(c53167658.reptg2)
	e3:SetValue(c53167658.repval)
	e3:SetOperation(c53167658.repop2)
	c:RegisterEffect(e3)
end
function c53167658.repfilter1(c,tp)
	return c:IsOnField() and c:IsControler(tp)
		and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp)) and not c:IsReason(REASON_REPLACE)
end
function c53167658.reptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c53167658.repfilter1,1,c,tp)
		and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		local sg=eg:Filter(c53167658.repfilter1,c,tp)
		if sg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(53167658,0))
			sg=sg:Select(tp,1,1,nil)
		end
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c53167658.repval(e,c)
	local g=e:GetLabelObject()
	return g:IsContains(c)
end
function c53167658.repop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
	local g=e:GetLabelObject()
	g:DeleteGroup()
end
function c53167658.repfilter2(c,tp)
	return c:IsOnField() and c:IsControler(1-tp)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c53167658.reptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c53167658.repfilter2,1,nil,tp) and c:IsAbleToRemove() end
	if Duel.SelectEffectYesNo(tp,c,96) then
		local sg=eg:Filter(c53167658.repfilter2,nil,tp)
		if sg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(53167658,0))
			sg=sg:Select(tp,1,1,nil)
		end
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c53167658.repop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
	local g=e:GetLabelObject()
	g:DeleteGroup()
end
