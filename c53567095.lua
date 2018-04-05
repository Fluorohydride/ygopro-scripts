--ゴッドバードアタック
function c53567095.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCost(c53567095.cost)
	e1:SetTarget(c53567095.target)
	e1:SetOperation(c53567095.activate)
	c:RegisterEffect(e1)
end
function c53567095.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c53567095.desfilter(c,tc)
	return c:GetEquipTarget()~=tc
end
function c53567095.costfilter(c)
	if not c:IsRace(RACE_WINDBEAST) then return false end
	return Duel.IsExistingTarget(c53567095.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,c,c)
end
function c53567095.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return Duel.CheckReleaseGroup(tp,c53567095.costfilter,1,e:GetHandler())
		else
			return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,e:GetHandler())
		end
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		local sg=Duel.SelectReleaseGroup(tp,c53567095.costfilter,1,1,e:GetHandler())
		Duel.Release(sg,REASON_COST)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,2,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function c53567095.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(sg,REASON_EFFECT)
end
