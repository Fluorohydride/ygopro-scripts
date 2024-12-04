--竜儀巧－メテオニス＝DRA
function c69815951.initial_effect(c)
	c:EnableReviveLimit()
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c69815951.valcheck)
	c:RegisterEffect(e0)
	--cannot be effect target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c69815951.efilter)
	c:RegisterEffect(e1)
	--attack all
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetCondition(c69815951.atkcon)
	e2:SetValue(c69815951.atkfilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c69815951.matcon)
	e3:SetOperation(c69815951.matop)
	c:RegisterEffect(e3)
	e0:SetLabelObject(e3)
	--to grave
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(69815951,0))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCountLimit(1,69815951)
	e4:SetCondition(c69815951.tgcon)
	e4:SetCost(c69815951.tgcost)
	e4:SetTarget(c69815951.tgtg)
	e4:SetOperation(c69815951.tgop)
	c:RegisterEffect(e4)
end
function c69815951.efilter(e,re,rp)
	return aux.tgoval(e,re,rp) and re:IsActiveType(TYPE_MONSTER)
end
function c69815951.atkcon(e)
	return e:GetHandler():GetFlagEffect(69815951)>0
end
function c69815951.atkfilter(e,c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c69815951.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) and e:GetLabel()==1
end
function c69815951.matop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(69815951,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(69815951,1))
end
function c69815951.lvfilter(c,rc)
	return c:GetRitualLevel(rc)>0
end
function c69815951.valcheck(e,c)
	local mg=c:GetMaterial()
	local fg=mg:Filter(c69815951.lvfilter,nil,c)
	if #fg>0 and fg:GetSum(Card.GetRitualLevel,c)<=2 then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c69815951.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c69815951.costfilter(c)
	return c:IsAttackAbove(1) and c:IsAbleToRemoveAsCost()
end
function c69815951.tgfilter(c)
	return c:IsFaceup() and c:IsAbleToGrave()
end
function c69815951.fselect(g,chk1,chk2)
	local sum=g:GetSum(Card.GetAttack)
	if chk2 then
		return sum==2000 or sum==4000
	elseif chk1 then
		return sum==2000
	end
	return false
end
function c69815951.gcheck(maxatk)
	return	function(g)
				return g:GetSum(Card.GetAttack)<=maxatk
			end
end
function c69815951.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100,0)
	local chk1=Duel.IsExistingTarget(c69815951.tgfilter,tp,0,LOCATION_ONFIELD,1,nil)
	local chk2=Duel.IsExistingTarget(c69815951.tgfilter,tp,0,LOCATION_ONFIELD,2,nil)
	local maxatk=2000
	if chk2 then maxatk=4000 end
	local g=Duel.GetMatchingGroup(c69815951.costfilter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then
		if not chk1 then return false end
		aux.GCheckAdditional=c69815951.gcheck(maxatk)
		local res=g:CheckSubGroup(c69815951.fselect,1,#g,chk1,chk2)
		aux.GCheckAdditional=nil
		return res
	end
	aux.GCheckAdditional=c69815951.gcheck(maxatk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,c69815951.fselect,false,1,#g,chk1,chk2)
	aux.GCheckAdditional=nil
	if sg:GetSum(Card.GetAttack)==4000 then
		e:SetLabel(100,2)
	else
		e:SetLabel(100,1)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c69815951.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c69815951.tgfilter(chkc) end
	local check,ct=e:GetLabel()
	if chk==0 then
		e:SetLabel(0,0)
		if check~=100 then return false end
		return Duel.IsExistingTarget(c69815951.tgfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	e:SetLabel(0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c69815951.tgfilter,tp,0,LOCATION_ONFIELD,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
end
function c69815951.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
