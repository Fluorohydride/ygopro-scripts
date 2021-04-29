--召喚魔術
function c74063034.initial_effect(c)
	--Activate
	local e1=aux.AddFusionEffectProcUltimate(c,{
		mat_location=LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,
		mat_operation=c74063034.mat_operation,
		grave_filter=Card.IsAbleToRemove,
		grave_operation=aux.FMaterialRemove,
		get_extra_mat=c74063034.get_extra_mat,
		fcheck=c74063034.fcheck
	})
	e1:SetDescription(aux.Stringid(74063034,0))
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(74063034,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,74063034)
	e2:SetTarget(c74063034.tdtg)
	e2:SetOperation(c74063034.tdop)
	c:RegisterEffect(e2)
end
function c74063034.mat_operation(mat)
	local mat1=mat:Filter(Card.IsLocation,nil,LOCATION_HAND)
	mat:Sub(mat1)
	aux.FMaterialToGrave(mat1)
	aux.FMaterialRemove(mat)
end
function c74063034.mfilter1(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c74063034.get_extra_mat(e,tp)
	return Duel.GetMatchingGroup(c74063034.mfilter1,tp,0,LOCATION_GRAVE,nil,e)
end
function c74063034.exfilter(c)
	return not c:IsLocation(LOCATION_HAND)
end
function c74063034.fcheck(tp,sg,fc)
	if fc:IsSetCard(0xf4) then
		return true
	else
		return not sg:IsExists(c74063034.exfilter,1,nil)
	end
end
function c74063034.thfilter(c)
	return c:IsFaceup() and c:IsCode(86120751) and c:IsAbleToHand()
end
function c74063034.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c74063034.thfilter(chkc) end
	if chk==0 then return e:GetHandler():IsAbleToDeck()
		and Duel.IsExistingTarget(c74063034.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c74063034.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c74063034.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
