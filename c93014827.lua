--ゼロ・デイ・ブラスター
function c93014827.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c93014827.cost)
	e1:SetTarget(c93014827.target)
	e1:SetOperation(c93014827.activate)
	c:RegisterEffect(e1)
end
function c93014827.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c93014827.desfilter(c,tc,ec)
	return c:GetEquipTarget()~=tc and c~=ec
end
function c93014827.costfilter(c,ec,tp)
	local lk=c:GetLink()
	if not c:IsType(TYPE_LINK) or not c:IsAttribute(ATTRIBUTE_DARK) or lk<=0 then return false end
	return Duel.IsExistingTarget(c93014827.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,lk,c,c,ec)
end
function c93014827.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc~=c end
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return Duel.CheckReleaseGroup(tp,c93014827.costfilter,1,c,c,tp)
		else return false end
	end
	e:SetLabel(0)
	local sg=Duel.SelectReleaseGroup(tp,c93014827.costfilter,1,1,c,c,tp)
	local lk=sg:GetFirst():GetLink()
	Duel.Release(sg,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,lk,lk,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c93014827.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(g,REASON_EFFECT)
end
