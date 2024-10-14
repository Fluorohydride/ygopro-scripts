--烈風帝ライザー
---@param c Card
function c69327790.initial_effect(c)
	--summon with 1 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69327790,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c69327790.otcon)
	e1:SetOperation(c69327790.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e2)
	--todeck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(69327790,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCondition(c69327790.tdcon)
	e3:SetTarget(c69327790.tdtg)
	e3:SetOperation(c69327790.tdop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(c69327790.valcheck)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
end
function c69327790.otfilter(c)
	return c:IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c69327790.otcon(e,c,minc)
	if c==nil then return true end
	local mg=Duel.GetMatchingGroup(c69327790.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	return c:IsLevelAbove(7) and minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function c69327790.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c69327790.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	local sg=Duel.SelectTribute(tp,c,1,1,mg)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c69327790.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c69327790.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return true end
	local g1=nil
	if Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingTarget(nil,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		g1=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g2=Duel.SelectTarget(tp,nil,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
		e:SetLabelObject(g2:GetFirst())
		g1:Merge(g2)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,2,0,0)
	end
	if e:GetLabel()==1
		and Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,g1)
		and Duel.SelectYesNo(tp,aux.Stringid(69327790,2)) then
		e:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g3=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,g1)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g3,1,0,0)
	else
		e:SetCategory(CATEGORY_TODECK)
	end
end
function c69327790.tdop(e,tp,eg,ep,ev,re,r,rp)
	local ex,g1=Duel.GetOperationInfo(0,CATEGORY_TODECK)
	local ex2,g2=Duel.GetOperationInfo(0,CATEGORY_TOHAND)
	if g1 then
		local sg1=g1:Filter(Card.IsRelateToEffect,nil,e)
		if sg1:GetCount()>0 and Duel.SendtoDeck(sg1,nil,SEQ_DECKTOP,REASON_EFFECT)>1 then
			local gc=e:GetLabelObject()
			local fc=sg1:GetFirst()
			if fc==gc then fc=sg1:GetNext() end
			if fc:GetControler()==gc:GetControler() and fc:IsLocation(LOCATION_DECK) and gc:IsLocation(LOCATION_DECK) then
				local op=Duel.SelectOption(tp,aux.Stringid(69327790,3),aux.Stringid(69327790,4))
				if op==0 then
					Duel.MoveSequence(fc,SEQ_DECKTOP)
				else
					Duel.MoveSequence(gc,SEQ_DECKTOP)
				end
			end
		end
	end
	if e:GetLabel()==1 and g2 then
		local tc=g2:GetFirst()
		if tc:IsRelateToEffect(e) then
			Duel.BreakEffect()
			Duel.SendtoHand(g2,nil,REASON_EFFECT)
		end
	end
end
function c69327790.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_WIND) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
