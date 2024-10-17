--磁石の戦士マグネット・バルキリオン
---@param c Card
function c75347539.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c75347539.spcon)
	e1:SetTarget(c75347539.sptg)
	e1:SetOperation(c75347539.spop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75347539,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c75347539.cost)
	e2:SetTarget(c75347539.target)
	e2:SetOperation(c75347539.operation)
	c:RegisterEffect(e2)
end
c75347539.spchecks=aux.CreateChecks(Card.IsCode,{99785935,39256679,11549357})
function c75347539.fselect(g,tp)
	return aux.mzctcheck(g,tp) and Duel.CheckReleaseGroupEx(tp,aux.IsInGroup,#g,REASON_SPSUMMON,true,nil,g)
end
function c75347539.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetReleaseGroup(tp,true,REASON_SPSUMMON)
	return g:CheckSubGroupEach(c75347539.spchecks,c75347539.fselect,tp)
end
function c75347539.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetReleaseGroup(tp,true,REASON_SPSUMMON)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:SelectSubGroupEach(tp,c75347539.spchecks,true,c75347539.fselect,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c75347539.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
	g:DeleteGroup()
end
function c75347539.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c75347539.spfilter(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75347539.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2
		and Duel.IsExistingTarget(c75347539.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,99785935)
		and Duel.IsExistingTarget(c75347539.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,39256679)
		and Duel.IsExistingTarget(c75347539.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,11549357) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c75347539.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,99785935)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,c75347539.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,39256679)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g3=Duel.SelectTarget(tp,c75347539.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,11549357)
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,3,0,0)
end
function c75347539.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 then return end
	if g:GetCount()>=2 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if g:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=g:Select(tp,ft,ft,nil)
	end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
