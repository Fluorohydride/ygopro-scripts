--激動の未界域
function c23213239.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23213239,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c23213239.bdcon)
	e2:SetTarget(c23213239.bdtg)
	e2:SetOperation(c23213239.bdop)
	c:RegisterEffect(e2)
	--destroy all
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(23213239,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,23213239)
	e3:SetCost(c23213239.descost)
	e3:SetTarget(c23213239.destg)
	e3:SetOperation(c23213239.desop)
	c:RegisterEffect(e3)
end
function c23213239.cfilter(c,tp)
	local rc=c:GetReasonCard()
	return c:IsReason(REASON_BATTLE) and c:GetPreviousControler()==tp and c:IsSetCard(0x11e)
		and rc and rc:IsControler(1-tp) and rc:IsRelateToBattle()
end
function c23213239.bdcon(e,tp,eg,ep,ev,re,r,rp)
	local dc=eg:Filter(c23213239.cfilter,nil,tp):GetFirst()
	if dc then
		e:SetLabelObject(dc:GetReasonCard())
		return true
	else return false end
end
function c23213239.bdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetLabelObject(),1,0,0)
end
function c23213239.bdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc and tc:IsRelateToBattle() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c23213239.costfilter(c)
	return c:IsSetCard(0x11e) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemoveAsCost()
end
function c23213239.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c23213239.costfilter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function c23213239.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c23213239.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c23213239.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c23213239.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x11e)
end
