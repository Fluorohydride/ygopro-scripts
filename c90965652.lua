--二量合成
function c90965652.initial_effect(c)
	aux.AddCodeList(c,65959844,25669282)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(90965652,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,90965652)
	e1:SetTarget(c90965652.target)
	e1:SetOperation(c90965652.activate)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(90965652,3))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,90965653)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c90965652.atktg)
	e2:SetOperation(c90965652.atkop)
	c:RegisterEffect(e2)
end
c90965652.has_text_type=TYPE_DUAL
function c90965652.thfilter1(c)
	return c:IsCode(65959844) and c:IsAbleToHand()
end
function c90965652.thfilter2(c)
	return c:IsCode(25669282) and c:IsAbleToHand()
end
function c90965652.thfilter3(c)
	return c:IsSetCard(0xeb) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c90965652.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c90965652.thfilter1,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c90965652.thfilter2,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c90965652.thfilter3,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(90965652,1)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(90965652,2)
		opval[off-1]=2
		off=off+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local res=opval[op]
	e:SetLabel(res)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,res,tp,LOCATION_DECK)
end
function c90965652.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c90965652.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		if Duel.IsExistingMatchingCard(c90965652.thfilter2,tp,LOCATION_DECK,0,1,nil)
			and Duel.IsExistingMatchingCard(c90965652.thfilter3,tp,LOCATION_DECK,0,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g1=Duel.SelectMatchingCard(tp,c90965652.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g2=Duel.SelectMatchingCard(tp,c90965652.thfilter3,tp,LOCATION_DECK,0,1,1,nil)
			g1:Merge(g2)
			Duel.SendtoHand(g1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g1)
		end
	end
end
function c90965652.tgfilter(c,e)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function c90965652.atkfilter(c)
	return c:GetAttack()>0 and c:GetBaseAttack()>0
end
function c90965652.tgcheck(g)
	return g:IsExists(Card.IsDualState,1,nil) and g:IsExists(c90965652.atkfilter,1,nil)
end
function c90965652.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c90965652.tgfilter,tp,LOCATION_MZONE,0,nil,e)
	if chk==0 then return g:CheckSubGroup(c90965652.tgcheck,2,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=g:SelectSubGroup(tp,c90965652.tgcheck,false,2,2)
	Duel.SetTargetCard(sg)
end
function c90965652.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e):Filter(Card.IsFaceup,nil)
	if #g<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(90965652,4))
	local g1=g:FilterSelect(tp,c90965652.atkfilter,1,1,nil)
	if #g1<1 then return end
	local tc1=g1:GetFirst()
	local tc2=(g-g1):GetFirst()
	if tc1:IsImmuneToEffect(e) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(0)
	tc1:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e2:SetValue(tc1:GetBaseAttack())
	tc2:RegisterEffect(e2)
end
