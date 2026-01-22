--E・HERO バブルマン・ネオ
function c5285665.initial_effect(c)
	aux.AddCodeList(c,79979666,46411259)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c5285665.spcon)
	e2:SetTarget(c5285665.sptg)
	e2:SetOperation(c5285665.spop)
	c:RegisterEffect(e2)
	--change code
	aux.EnableChangeCode(c,79979666)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(5285665,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_DAMAGE_STEP_END)
	e4:SetCondition(aux.dsercon)
	e4:SetTarget(c5285665.destg)
	e4:SetOperation(c5285665.desop)
	c:RegisterEffect(e4)
end
function c5285665.spfilter(c)
	return c:IsCode(79979666,46411259) and c:IsAbleToGraveAsCost()
end
function c5285665.spfilter1(c,tp)
	return c:IsCode(79979666) and c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and Duel.GetMZoneCount(tp,c)>0
end
function c5285665.spfilter2(c)
	return c:IsCode(46411259) and c:IsLocation(LOCATION_HAND)
end
function c5285665.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c5285665.spfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(aux.gffcheck,2,2,c5285665.spfilter1,tp,c5285665.spfilter2,nil)
end
function c5285665.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c5285665.spfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,aux.gffcheck,true,2,2,c5285665.spfilter1,tp,c5285665.spfilter2,nil)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c5285665.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_SPSUMMON)
	g:DeleteGroup()
end
function c5285665.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return bc and bc:IsRelateToBattle() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
end
function c5285665.desop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsRelateToBattle() then
		Duel.Destroy(bc,REASON_EFFECT)
	end
end
